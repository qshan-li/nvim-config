return function()
	require("pure-nvim.utils").load_plugin("tiny-inline-diagnostic", {
		preset = "simple",
		options = {
			show_source = {
				enabled = true,
				if_many = true,
			},
			add_messages = true,
			set_arrow_to_diag_color = false,
			use_icons_from_diagnostic = true,
			show_all_diags_on_cursorline = false,
			break_line = {
				enabled = true,
				after = 80,
			},
			-- Filter severities up to the diagnostics level setting
			severity = vim.tbl_filter(function(level)
				return level <= vim.diagnostic.severity[require("pure-nvim.core.settings").diagnostics_level]
			end, {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.INFO,
				vim.diagnostic.severity.HINT,
			}),
		},
		disabled_ft = {
			"minintro",
			"checkhealth",
			"diff",
			"help",
			"log",
			"notify",
			"qf",
			"toggleterm",
		},
	})

	-- Keep this aligned with the built-in diagnostic virtual text toggle.
	require("tiny-inline-diagnostic")[require("pure-nvim.core.settings").diagnostics_virtual_text and "enable" or "disable"]()
end
