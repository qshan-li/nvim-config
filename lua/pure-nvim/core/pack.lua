local fn, api = vim.fn, vim.api
local global = require("pure-nvim.core.global")
local is_mac = global.is_mac
local vim_path = global.vim_path
local data_dir = global.data_dir
local pure_lazy_root = data_dir .. "lazy-pure"
local lazy_path = pure_lazy_root .. "/lazy.nvim"
local modules_dir = vim_path .. "/lua/pure-nvim"

local settings = require("pure-nvim.core.settings")
local use_ssh = settings.use_ssh

local icons = {
	kind = require("pure-nvim.utils.icons").get("kind"),
	documents = require("pure-nvim.utils.icons").get("documents"),
	ui = require("pure-nvim.utils.icons").get("ui"),
	ui_sep = require("pure-nvim.utils.icons").get("ui", true),
	misc = require("pure-nvim.utils.icons").get("misc"),
}

local Lazy = {}

function Lazy:load_plugins()
	self.modules = {}

	local append_nativertp = function()
		package.path = package.path
			.. string.format(";%s;%s", modules_dir .. "/configs/?.lua", modules_dir .. "/configs/?/init.lua")
	end

	local get_plugins_list = function()
		local list = {}
		local plugins_list = vim.split(fn.glob(modules_dir .. "/plugins/*.lua"), "\n", { trimempty = true })
		for _, f in ipairs(plugins_list) do
			local basename = fn.fnamemodify(f, ":t:r")
			list[#list + 1] = "pure-nvim.plugins." .. basename
		end
		return list
	end

	append_nativertp()

	for _, m in ipairs(get_plugins_list()) do
		local modules = require(m)
		if type(modules) == "table" then
			for name, conf in pairs(modules) do
				self.modules[#self.modules + 1] = vim.tbl_extend("force", { name }, conf)
			end
		end
	end
	for _, name in ipairs(settings.disabled_plugins) do
		self.modules[#self.modules + 1] = { name, enabled = false }
	end
end

function Lazy:load_lazy()
	if not vim.uv.fs_stat(lazy_path) then
		vim.fn.mkdir(vim.fn.fnamemodify(lazy_path, ":h"), "p")
		local lazy_repo = use_ssh and "git@github.com:folke/lazy.nvim.git " or "https://github.com/folke/lazy.nvim.git "
		api.nvim_command("!git clone --filter=blob:none --branch=stable " .. lazy_repo .. lazy_path)
	end
	self:load_plugins()

	local clone_prefix = use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git"
	local lazy_settings = {
		root = pure_lazy_root,
		lockfile = vim_path .. "/lazy-lock-pure.json",
		git = {
			-- log = { "-10" }, -- show the last 10 commits
			timeout = 300,
			url_format = clone_prefix,
		},
		install = {
			-- install missing plugins on startup. This doesn't increase startup time.
			missing = true,
			colorscheme = { settings.colorscheme },
		},
		ui = {
			-- a number <1 is a percentage., >1 is a fixed size
			size = { width = 0.88, height = 0.8 },
			wrap = true, -- wrap the lines in the ui
			-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
			border = "rounded",
			icons = {
				cmd = icons.misc.Code,
				config = icons.ui.Gear,
				event = icons.kind.Event,
				ft = icons.documents.Files,
				init = icons.misc.ManUp,
				import = icons.documents.Import,
				keys = icons.ui.Keyboard,
				loaded = icons.ui.Check,
				not_loaded = icons.misc.Ghost,
				plugin = icons.ui.Package,
				runtime = icons.misc.Vim,
				source = icons.kind.StaticMethod,
				start = icons.ui.Play,
				list = {
					icons.ui_sep.BigCircle,
					icons.ui_sep.BigUnfilledCircle,
					icons.ui_sep.Square,
					icons.ui_sep.ChevronRight,
				},
			},
		},
		performance = {
			cache = {
				enabled = true,
				path = vim.fn.stdpath("cache") .. "/lazy/cache",
				-- Once one of the following events triggers, caching will be disabled.
				-- To cache all modules, set this to `{}`, but that is not recommended.
				disable_events = { "UIEnter", "BufReadPre" },
				ttl = 3600 * 24 * 2, -- keep unused modules for up to 2 days
			},
			reset_packpath = true, -- reset the package path to improve startup time
			rtp = {
				reset = true, -- reset the runtime path to $VIMRUNTIME and the config directory
				---@type string[]
				paths = {}, -- add any custom paths here that you want to include in the rtp
				disabled_plugins = {
					-- Comment out `"editorconfig"` to enable native EditorConfig support
					-- WARN: Sleuth.vim already includes all the features provided by this plugin.
					--       Do NOT enable both at the same time, or you risk breaking the entire detection system.
					"editorconfig",
					-- Do not load spell files
					"spellfile",
					-- Do not use builtin matchit.vim and matchparen.vim because we're using vim-matchup
					"matchit",
					"matchparen",
					-- Do not load tohtml.vim
					"tohtml",
					-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all of these plugins are
					-- related to reading files inside compressed containers)
					"gzip",
					"tarPlugin",
					"zipPlugin",
					-- Disable remote plugins
					-- NOTE:
					--  > Disabling rplugin.vim will make `wilder.nvim` complain about missing rplugins during :checkhealth,
					--  > but since its config doesn't require python rtp (strictly), it's fine to ignore that for now.
					-- "rplugin",
				},
			},
		},
	}
	if is_mac then
		lazy_settings.concurrency = 20
	end

	vim.opt.rtp:prepend(lazy_path)
	require("lazy").setup(self.modules, lazy_settings)
end

Lazy:load_lazy()
