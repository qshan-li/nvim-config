return function()
	local clear = {}
	local transparent_background = require("pure-nvim.core.settings").transparent_background

	require("pure-nvim.utils").load_plugin("catppuccin", {
		background = { light = "latte", dark = "mocha" }, -- latte, frappe, macchiato, mocha
		dim_inactive = {
			enabled = false,
			-- Dim inactive splits/windows/buffers.
			-- NOT recommended if you use old palette (a.k.a., mocha).
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = transparent_background,
		show_end_of_buffer = false, -- show the '~' characters after the end of buffers
		term_colors = true,
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		styles = {
			comments = {},
			functions = { "bold" },
			keywords = {},
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold" },
			numbers = {},
			types = {},
			strings = {},
			variables = {},
			properties = {},
		},
		integrations = {
			diffview = true,
			dropbar = { enabled = true, color_mode = true },
			flash = true,
			fzf = true,
			gitsigns = true,
			grug_far = true,
			indent_blankline = { enabled = true, colored_indent_levels = true },
			markdown = true,
			mini = { enabled = true },
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = {},
					hints = {},
					warnings = {},
					information = {},
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			nvimtree = true,
			rainbow_delimiters = true,
			render_markdown = true,
			semantic_tokens = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
		color_overrides = {},
		highlight_overrides = {
			---@param cp palette
			all = function(cp)
				return {
					-- For base configs
					NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
					FloatBorder = {
						fg = transparent_background and cp.blue or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},
					CursorLineNr = { fg = cp.green },

					-- For native lsp configs
					DiagnosticVirtualTextError = { bg = cp.none },
					DiagnosticVirtualTextWarn = { bg = cp.none },
					DiagnosticVirtualTextInfo = { bg = cp.none },
					DiagnosticVirtualTextHint = { bg = cp.none },
					LspInfoBorder = { link = "FloatBorder" },

					-- For mason.nvim
					MasonNormal = { link = "NormalFloat" },

					-- For indent-blankline
					IblIndent = { fg = cp.surface0 },
					IblScope = { fg = cp.surface2, style = { "bold" } },

					-- For nvim-cmp and wilder.nvim
					Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
					PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
					PmenuSel = { bg = cp.green, fg = cp.base },
					CmpItemAbbr = { fg = cp.overlay2 },
					CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
					CmpDoc = { link = "NormalFloat" },
					CmpDocBorder = {
						fg = transparent_background and cp.surface1 or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},

					-- For fidget
					FidgetTask = { bg = cp.none, fg = cp.surface2 },
					FidgetTitle = { fg = cp.blue, style = { "bold" } },

					-- For nvim-notify
					NotifyBackground = { bg = cp.base },

					-- For trouble.nvim
					TroubleNormal = { bg = transparent_background and cp.none or cp.base },
					TroubleNormalNC = { bg = transparent_background and cp.none or cp.base },

					-- For glance.nvim
					GlanceWinBarFilename = { fg = cp.subtext1, style = { "bold" } },
					GlanceWinBarFilepath = { fg = cp.subtext0 },
					GlanceWinBarTitle = { fg = cp.teal, style = { "bold" } },
					GlanceListCount = { fg = cp.lavender },
					GlanceListFilepath = { link = "Comment" },
					GlanceListFilename = { fg = cp.blue },
					GlanceListMatch = { fg = cp.lavender, style = { "bold" } },
					GlanceFoldIcon = { fg = cp.green },

					-- For treesitter
					["@keyword.return"] = { fg = cp.pink, style = clear },
					["@error.c"] = { fg = cp.none, style = clear },
					["@error.cpp"] = { fg = cp.none, style = clear },
				}
			end,
		},
	})
end
