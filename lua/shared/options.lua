local M = {}

local diagnostic_virtual_text_groups = {
	"DiagnosticVirtualTextError",
	"DiagnosticVirtualTextWarn",
	"DiagnosticVirtualTextInfo",
	"DiagnosticVirtualTextHint",
}

local function set_diagnostic_virtual_text_colors()
	for _, group in ipairs(diagnostic_virtual_text_groups) do
		vim.api.nvim_set_hl(0, group, { fg = "#ff0000" })
	end
end

function M.setup()
	if M.loaded then
		return
	end
	M.loaded = true

	-- Leader 必须在加载插件之前设置
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Nerd Font
	vim.g.have_nerd_font = true

	set_diagnostic_virtual_text_colors()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = set_diagnostic_virtual_text_colors,
	})
end

return M
