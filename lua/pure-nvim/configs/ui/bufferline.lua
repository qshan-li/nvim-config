return function()
	local icons = { ui = require("pure-nvim.utils.icons").get("ui") }
	local colorscheme_name = vim.g.colors_name or ""

	local opts = {
		options = {
			always_show_bufferline = true,
			close_command = "BufDel! %d",
			right_mouse_command = "BufDel! %d",
			tab_size = 20,
			separator_style = "thin",
			show_buffer_icons = true,
			show_tab_indicators = true,
			show_buffer_close_icons = true,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
			numbers = nil,
			max_name_length = 20,
			max_prefix_length = 13,
			buffer_close_icon = icons.ui.Close,
			left_trunc_marker = icons.ui.Left,
			right_trunc_marker = icons.ui.Right,
			modified_icon = icons.ui.Modified_alt,
		},
		highlights = {},
	}

	if colorscheme_name:find("rose%-pine") then
		opts.highlights = require("rose-pine.plugins.bufferline")
	end

	require("pure-nvim.utils").load_plugin("bufferline", opts)
end
