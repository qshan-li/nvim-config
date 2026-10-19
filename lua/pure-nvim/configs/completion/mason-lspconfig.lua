local M = {}

M.setup = function()
	local settings = require("pure-nvim.core.settings")
	local utils = require("pure-nvim.utils")
	local mason_registry = require("mason-registry")
	local mason_lspconfig = require("mason-lspconfig")

	utils.load_plugin("mason-lspconfig", {
		ensure_installed = settings.mason_lsp_servers,
		-- Skip auto enable because we are loading language servers lazily
		automatic_enable = false,
	})

	require("completion.diagnostics").setup()

	local opts = {
		capabilities = utils.get_lsp_capabilities(),
	}

	local package_to_lspconfig = mason_lspconfig.get_mappings().package_to_lspconfig
	if not package_to_lspconfig or vim.tbl_isempty(package_to_lspconfig) then
		package_to_lspconfig = {}
		for _, spec in ipairs(mason_registry.get_all_package_specs()) do
			local lspconfig_name = vim.tbl_get(spec, "neovim", "lspconfig")
			if lspconfig_name then
				package_to_lspconfig[spec.name] = lspconfig_name
			end
		end
	end

	local allowed_servers = {}
	for _, name in ipairs(settings.mason_lsp_servers) do
		allowed_servers[name] = true
	end

	---A handler to setup all servers defined under `completion/servers/*.lua`
	---@param lsp_name string
	local function mason_lsp_handler(lsp_name)
		-- rust_analyzer is configured using mrcjkb/rustaceanvim
		-- warn users if they have set it up manually
		if lsp_name == "rust_analyzer" then
			local config_exist = pcall(require, "completion.servers." .. lsp_name)
			if config_exist then
				vim.notify(
					[[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
					vim.log.levels.WARN,
					{ title = "nvim-lspconfig" }
				)
			end
			return
		end

		local ok, custom_handler = pcall(require, "completion.servers." .. lsp_name)

		if not ok then
			-- Default to use factory config for server(s) that doesn't include a spec
			utils.register_server(lsp_name, opts)
		elseif type(custom_handler) == "function" then
			-- Case where language server requires its own setup
			-- Be sure to call `vim.lsp.config()` within the setup function.
			-- Refer to |vim.lsp.config()| for documentation.
			-- For an example, see `clangd.lua`.
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			utils.register_server(lsp_name, vim.tbl_deep_extend("force", opts, custom_handler))
		else
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
					lsp_name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-lspconfig" }
			)
		end
	end

	---A simplified mimic of <mason-lspconfig 1.x>'s `setup_handlers` callback.
	---Invoked for each Mason package (name or `Package` object) to configure its language server.
	---@param pkg string|{name: string} Either the package name (string) or a Package object
	local function setup_lsp_for_package(pkg)
		local name = type(pkg) == "string" and pkg or pkg.name
		local lsp_name = package_to_lspconfig[name]
		if not lsp_name then
			return
		end
		-- 只注册 settings 里显式列出的服务器。
		-- 否则像 stylua 这类同时提供 LSP 模式的格式化工具会被误当成语言服务器。
		if not allowed_servers[lsp_name] then
			return
		end

		mason_lsp_handler(lsp_name)
	end

	for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
		setup_lsp_for_package(pkg)
	end

	-- Ensure servers installed during the current session are registered immediately.
	mason_registry:on("package:install:success", function(pkg)
		setup_lsp_for_package(pkg)
	end)
end

return M
