local settings = require("pure-nvim.core.settings")
local global = require("pure-nvim.core.global")

-- Create cache dir and data dirs
local createdir = function()
	local data_dirs = {
		global.cache_dir .. "/backup",
		global.cache_dir .. "/session",
		global.cache_dir .. "/swap",
		global.cache_dir .. "/tags",
		global.cache_dir .. "/undo",
		global.vim_path .. "/spell",
	}
	if vim.fn.isdirectory(global.cache_dir) == 0 then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.fn.mkdir(global.cache_dir, "p")
	end
	for _, dir in ipairs(data_dirs) do
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end
end

local gui_config = function()
	if next(settings.gui_config) then
		vim.api.nvim_set_option_value(
			"guifont",
			settings.gui_config.font_name .. ":h" .. settings.gui_config.font_size,
			{}
		)
	end
end

local neovide_config = function()
	for name, config in pairs(settings.neovide_config) do
		vim.g["neovide_" .. name] = config
	end
end

local clipboard_config = function()
	if global.is_mac then
		vim.g.clipboard = {
			name = "macOS-clipboard",
			copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
			paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
			cache_enabled = 0,
		}
	elseif global.is_wsl then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	elseif global.is_linux then
		if vim.fn.executable("wl-copy") == 1 then
			vim.g.clipboard = {
				name = "wayland-clipboard",
				copy = {
					["+"] = "wl-copy --foreground --type text/plain",
					["*"] = "wl-copy --foreground --type text/plain",
				},
				paste = {
					["+"] = "wl-paste --no-newline",
					["*"] = "wl-paste --no-newline",
				},
				cache_enabled = 0,
			}
		elseif vim.fn.executable("xclip") == 1 then
			vim.g.clipboard = {
				name = "xclip-clipboard",
				copy = {
					["+"] = "xclip -selection clipboard",
					["*"] = "xclip -selection primary",
				},
				paste = {
					["+"] = "xclip -selection clipboard -o",
					["*"] = "xclip -selection primary -o",
				},
				cache_enabled = 0,
			}
		elseif vim.fn.executable("xsel") == 1 then
			vim.g.clipboard = {
				name = "xsel-clipboard",
				copy = {
					["+"] = "xsel --clipboard --input",
					["*"] = "xsel --primary --input",
				},
				paste = {
					["+"] = "xsel --clipboard --output",
					["*"] = "xsel --primary --output",
				},
				cache_enabled = 0,
			}
		else
			vim.notify("No clipboard tool found. Install one of: wl-copy, xclip, xsel", vim.log.levels.WARN)
		end
	end
end

local shell_config = function()
	if global.is_windows then
		if not (vim.fn.executable("pwsh") == 1 or vim.fn.executable("powershell") == 1) then
			vim.notify(
				[[
Failed to setup terminal config

PowerShell is either not installed, missing from PATH, or not executable;
cmd.exe will be used instead for `:!` (shell bang) and toggleterm.nvim.

You're recommended to install PowerShell for better experience.]],
				vim.log.levels.WARN,
				{ title = "[core] Runtime Warning" }
			)
			return
		end

		local basecmd = "-NoLogo -MTA -ExecutionPolicy RemoteSigned"
		local ctrlcmd = "-Command [console]::InputEncoding = [console]::OutputEncoding = [System.Text.Encoding]::UTF8"
		local set_opts = vim.api.nvim_set_option_value
		set_opts("shell", vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", {})
		set_opts("shellcmdflag", string.format("%s %s;", basecmd, ctrlcmd), {})
		set_opts("shellredir", "-RedirectStandardOutput %s -NoNewWindow -Wait", {})
		set_opts("shellpipe", "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode", {})
		set_opts("shellquote", "", {})
		set_opts("shellxquote", "", {})
	end
end

local load_core = function()
	createdir()

	gui_config()
	neovide_config()
	clipboard_config()
	shell_config()

	require("pure-nvim.core.options").setup()
	require("pure-nvim.core.event")
	require("pure-nvim.core.pack")
	require("pure-nvim.keymap")

	vim.api.nvim_set_option_value("background", settings.background, {})
	vim.cmd.colorscheme(settings.colorscheme)
end

load_core()
