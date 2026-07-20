local settings = {}

-- Set to false if you want to use HTTPS to update plugins and Treesitter parsers.
---@type boolean
settings["use_ssh"] = true

-- Set to false if you don't want to format on save.
---@type boolean
settings["format_on_save"] = true

-- Format timeout in milliseconds.
---@type number
settings["format_timeout"] = 1000

-- Set to false to disable format notification.
---@type boolean
settings["format_notify"] = false

-- Filetypes in this list will skip LSP formatting if the value is true.
---@type table<string, boolean>
settings["formatter_block_list"] = {
	-- Example
	lua = false,
}

-- Directories where formatting on save is disabled.
-- NOTE: Strings may contain regular expressions (vim regex). |regexp|
-- NOTE: Directories are automatically normalized using |vim.fs.normalize()|.
---@type string[]
settings["format_disabled_dirs"] = {
	-- Example
	"~/format_disabled_dir",
}

-- Set to false to disable inline diagnostic virtual text.
-- You can still view diagnostics using floats and trouble.nvim.
---@type boolean
settings["diagnostics_virtual_text"] = true

-- Set the minimum severity level of diagnostics to display.
-- Priority: `Error` > `Warning` > `Information` > `Hint`.
-- For example, if set to `Warning`, only warnings and errors will be shown.
-- NOTE: This only works when `diagnostics_virtual_text` is true.
---@type "ERROR"|"WARN"|"INFO"|"HINT"
settings["diagnostics_level"] = "HINT"

-- List plugins to disable here (e.g., "Some-User/A-Repo").
---@type string[]
settings["disabled_plugins"] = {}

-- Set to false if you don't use Neovim to open large files.
---@type boolean
settings["load_big_files_faster"] = true

-- Customize the global color palette here.
-- These settings will override the defaults during initialization.
-- Parameters will auto-complete as you type.
-- Example: { sky = "#04A5E5" }
---@type palette[]
settings["palette_overwrite"] = {}

-- Set the colorscheme here.
-- Valid options: `rose-pine`, `rose-pine-main`, `rose-pine-moon`, `rose-pine-dawn`, `vitesse`, `vitesse-dark`, `vitesse-light`, `vitesse-black`.
---@type string
settings["colorscheme"] = "rose-pine"

-- Set to true if your terminal supports a transparent background.
---@type boolean
settings["transparent_background"] = false

-- Set the background mode here.
-- Useful for themes with both light and dark variants.
-- Valid values: `dark`, `light`.
---@type "dark"|"light"
settings["background"] = "light"

-- Set to false to disable LSP inlay hints.
---@type boolean
settings["lsp_inlayhints"] = false

-- Mason-managed LSP servers to install.
-- Full list: https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
---@type string[]
settings["mason_lsp_servers"] = {
	"bashls",
	"clangd",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"ruff",
	"vtsls",
	"vue_ls",
	"zuban",
}

-- Mason-managed tools (formatters, linters) to install.
-- These are discovered by conform.nvim / nvim-lint via PATH.
---@type string[]
settings["mason_tools"] = {
	"clang-format",
	"gofumpt",
	"goimports",
	"prettier",
	"shfmt",
	"stylua",
	"vint",
}

-- Mason-managed DAP adapters to install and configure.
-- Supported DAPs: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
---@type string[]
settings["mason_dap_adapters"] = {
	"codelldb", -- C-Family
	"delve", -- Go
	"python", -- Python (debugpy)
}

-- GUI settings for clients like `neovide` or `neovim-qt`.
-- NOTE: Only the following GUI options are supported; others will be ignored.
---@type { font_name: string, font_size: number }
settings["gui_config"] = {
	font_name = "JetBrainsMono Nerd Font",
	font_size = 9.5,
}

-- Specific settings for `neovide`.
-- Remove the `neovide_` prefix (with trailing underscore) from all entries below.
-- Supported entries: https://neovide.dev/configuration.html
---@type table<string, boolean|number|string>
settings["neovide_config"] = {
	no_idle = false,
	input_ime = true,
	fullscreen = true,
	padding_left = 8,
	confirm_quit = true,
	cursor_vfx_mode = "",
	cursor_trail_size = 0.05,
	cursor_antialiasing = true,
	hide_mouse_when_typing = true,
	input_macos_alt_is_meta = false,
	cursor_animation_length = 0.03,
	position_animation_length = 0.1,
	scroll_animation_length = 0.1,
	linespacing = 3,
}

return settings
