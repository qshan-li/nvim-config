return function()
	local settings = require("pure-nvim.core.settings")

	require("pure-nvim.utils").load_plugin("conform", {
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			objc = { "clang-format" },
			objcpp = { "clang-format" },
			cs = { "clang-format" },
			cuda = { "clang-format" },
			proto = { "clang-format" },
			lua = { "stylua" },
			go = { "gofumpt", "goimports" },
			sh = { "shfmt" },
			python = { lsp_format = "fallback" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			vue = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			markdown = { "prettier" },
		},
		formatters = {
			prettier = {
				require_cwd = true,
				cwd = require("conform.util").root_file({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.yml",
					".prettierrc.yaml",
					"prettier.config.js",
					"prettier.config.cjs",
				}),
			},
		},
		default_format_opts = {
			lsp_format = "fallback",
			timeout_ms = settings.format_timeout,
		},
		format_on_save = function(bufnr)
			if not settings.format_on_save then
				return
			end
			local filedir = vim.fn.expand("%:p:h")
			for _, dir in ipairs(settings.format_disabled_dirs) do
				if vim.regex(vim.fs.normalize(dir)):match_str(filedir) ~= nil then
					return
				end
			end
			if settings.formatter_block_list[vim.bo[bufnr].filetype] == true then
				return
			end
			return { timeout_ms = settings.format_timeout, lsp_format = "fallback" }
		end,
	})
end
