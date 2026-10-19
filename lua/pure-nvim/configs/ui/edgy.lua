return function()
	require("pure-nvim.utils").load_plugin("edgy", {
		animate = { enabled = false },
		close_when_all_hidden = true,
		exit_when_last = true,
		wo = { winbar = false },
		keys = {
			q = false,
			Q = false,
			["<C-q>"] = false,
			["<A-j>"] = function(win)
				win:resize("height", -2)
			end,
			["<A-k>"] = function(win)
				win:resize("height", 2)
			end,
			["<A-h>"] = function(win)
				win:resize("width", -2)
			end,
			["<A-l>"] = function(win)
				win:resize("width", 2)
			end,
		},
		left = {},
		bottom = {
			{ ft = "qf", size = { height = 0.3 } },
			{
				ft = "toggleterm",
				size = { height = 0.3 },
				filter = function(_, win)
					local cfg = vim.api.nvim_win_get_config(win)
					local term = require("toggleterm.terminal").get(1)
					return cfg.relative == "" and term and term.direction == "horizontal"
				end,
			},
			{
				ft = "help",
				size = { height = 0.3 },
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		right = {},
	})
end
