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

	-- 以下选项 vscode-neovim 扩展会读取，保证与纯 Neovim 侧行为一致
	-- unnamedplus: yy 等操作经由扩展的 g:vscode_clipboard 同步到系统剪贴板
	vim.o.clipboard = "unnamedplus"
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.timeoutlen = 300

	-- Nerd Font
	vim.g.have_nerd_font = true

	set_diagnostic_virtual_text_colors()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = set_diagnostic_virtual_text_colors,
	})
end

return M
