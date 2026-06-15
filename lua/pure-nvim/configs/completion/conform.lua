return function()
	local settings = require("pure-nvim.core.settings")
	local format_on_save = settings.format_on_save
	local format_notify = settings.format_notify
	local format_timeout = settings.format_timeout
	local formatter_block_list = settings.formatter_block_list

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

	vim.api.nvim_create_user_command("Format", function()
		require("conform").format({
			timeout_ms = format_timeout,
			lsp_format = "fallback",
		}, function(err)
			if not err and format_notify then
				vim.notify("Format successfully!", vim.log.levels.INFO, { title = "Conform" })
			end
		end)
	end, {})

	vim.api.nvim_create_user_command("FormatToggle", function()
		format_on_save = not format_on_save
		settings.format_on_save = format_on_save
		vim.notify(
			format_on_save and "Successfully enabled format-on-save" or "Successfully disabled format-on-save",
			format_on_save and vim.log.levels.INFO or vim.log.levels.WARN,
			{ title = "Settings modification success" }
		)
	end, {})

	vim.api.nvim_create_user_command("FormatterToggleFt", function(opts)
		if formatter_block_list[opts.args] == nil then
			vim.notify(
				string.format("[Conform] Formatter for [%s] has been recorded in list and disabled.", opts.args),
				vim.log.levels.WARN,
				{ title = "Conform Warning" }
			)
			formatter_block_list[opts.args] = true
		else
			formatter_block_list[opts.args] = not formatter_block_list[opts.args]
			vim.notify(
				string.format(
					"[Conform] Formatter for [%s] has been %s.",
					opts.args,
					not formatter_block_list[opts.args] and "enabled" or "disabled"
				),
				not formatter_block_list[opts.args] and vim.log.levels.INFO or vim.log.levels.WARN,
				{ title = string.format("Conform %s", not formatter_block_list[opts.args] and "Info" or "Warning") }
			)
		end
	end, { nargs = 1, complete = "filetype" })
end
