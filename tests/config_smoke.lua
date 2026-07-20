local command_names = { "Format", "FormatToggle", "SmartCursorMoveLeft", "BufferLineGoToBuffer" }
for _, name in ipairs(command_names) do
	assert(vim.fn.exists(":" .. name) == 2, name .. " command is unavailable at startup")
end

local lazy_lockfile = require("lazy.core.config").options.lockfile
local config_path = vim.uv.fs_realpath(vim.fn.stdpath("config"))
assert(lazy_lockfile == config_path .. "/lazy-lock-pure.json", "pure Neovim lockfile is incorrect")
assert(require("lazy.core.config").options.root:match("/site/lazy%-pure$"), "pure Neovim plugin root is not isolated")

local diagnostic_highlight = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError", link = false })
assert(diagnostic_highlight.fg == 0xff0000, "diagnostic virtual text should stay red after loading the colorscheme")

local normal_alt_one = vim.fn.maparg("<A-1>", "n", false, true)
assert(normal_alt_one.rhs == ":BufferLineGoToBuffer 1<CR>", "normal Alt-1 should switch buffers")

local terminal_alt_one = vim.fn.maparg("<A-1>", "t", false, true)
assert(terminal_alt_one.desc == "terminal: Panel 1", "terminal Alt-1 should switch panel terminals")

vim.cmd("enew")
vim.cmd("setfiletype markdown")
assert(vim.fn.exists(":RenderMarkdown") == 2, "RenderMarkdown command should load for markdown buffers")
assert(vim.fn.exists(":MarkdownPreviewToggle") == 2, "MarkdownPreviewToggle should load for markdown buffers")
assert(vim.fn.maparg("<F1>", "n", false, true).buffer == 1, "markdown F1 mapping should be buffer-local")
assert(vim.fn.maparg("<F12>", "n", false, true).buffer == 1, "markdown F12 mapping should be buffer-local")

local plain_buffer = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(plain_buffer)
assert(next(vim.fn.maparg("<F1>", "n", false, true)) == nil, "markdown mappings must not leak globally")
