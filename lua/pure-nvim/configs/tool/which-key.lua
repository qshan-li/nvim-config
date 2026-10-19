return function()
	local icons = {
		ui = require("pure-nvim.utils.icons").get("ui"),
		misc = require("pure-nvim.utils.icons").get("misc"),
		git = require("pure-nvim.utils.icons").get("git", true),
		cmp = require("pure-nvim.utils.icons").get("cmp", true),
	}
	local i18n = require("shared.i18n")

	require("pure-nvim.utils").load_plugin("which-key", {
		preset = "classic",
		delay = vim.o.timeoutlen,
		triggers = {
			{ "<auto>", mode = "nixso" },
		},
		disable = {
			bt = { "terminal" },
			ft = { "toggleterm", "terminal", "term" },
		},

		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				motions = false,
				operators = false,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		win = {
			border = "none",
			padding = { 1, 2 },
			wo = { winblend = 0 },
		},
		expand = 1,
		icons = {
			group = "",
			rules = false,
			colors = false,
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			keys = {
				C = "C-",
				M = "A-",
				S = "S-",
				BS = "<BS> ",
				CR = "<CR> ",
				NL = "<NL> ",
				Esc = "<Esc> ",
				Tab = "<Tab> ",
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				Space = "<Space> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
			},
		},
		spec = {
			{ "<leader>g", group = icons.git.Git .. " " .. i18n.t("git") },
			{ "<leader>d", group = icons.ui.Bug .. " " .. i18n.t("debug") },
			{ "<leader>s", group = icons.cmp.tmux .. " " .. i18n.t("session") },
			{ "<leader>b", group = icons.ui.Buffer .. " " .. i18n.t("buffer") },
			{ "<leader>S", group = icons.ui.Search .. " " .. i18n.t("search") },
			{ "<leader>W", group = icons.ui.Window .. " " .. i18n.t("window") },
			{ "<leader>p", group = icons.ui.Package .. " " .. i18n.t("package") },
			{ "<leader>l", group = icons.misc.LspAvailable .. " " .. i18n.t("lsp") },
			{ "<leader>f", group = icons.ui.Telescope .. " " .. i18n.t("fuzzy_find") },
			{ "<leader>n", group = icons.ui.FolderOpen .. " " .. i18n.t("nvim_tree") },
		},
	})
end
