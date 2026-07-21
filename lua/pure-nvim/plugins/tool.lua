local tool = {}
local snacks_buffer_picker = {
	hidden = false,
	unloaded = true,
	current = true,
	sort_lastused = true,
	win = {
		input = {
			keys = {
				["<C-d>"] = { "bufdelete", mode = { "n", "i" }, desc = "Delete buffer" },
			},
		},
		list = {
			keys = {
				["d"] = "bufdelete",
			},
		},
	},
}

local snacks_picker_window_keys = {
	input = {
		keys = {
			-- Disable `<c-v>` edit_vsplit to keep terminal paste behavior intact.
			["<c-v>"] = false,
		},
	},
	list = {
		keys = {
			["<c-v>"] = false,
		},
	},
}

local snacks_picker_opts = {
	input = {
		enabled = true,
	},
	picker = {
		formatters = {
			file = {
				filename_first = true,
				truncate = "center",
				min_width = 40,
			},
		},
		sources = {
			smart = {
				multi = { "buffers", "recent", "files" },
				format = "file",
				transform = "unique_file",
			},
			files = { hidden = true },
			buffers = snacks_buffer_picker,
		},
		-- Disabling preview syntax highlighting keeps the picker responsive in large repos.
		previewers = {
			file = {
				ft = "",
			},
		},
		win = snacks_picker_window_keys,
	},
}

-- This is specifically for fcitx5 users who code in languages other than English
-- tool["pysan3/fcitx5.nvim"] = {
-- 	lazy = true,
-- 	event = "BufReadPost",
-- 	cond = vim.fn.executable("fcitx5-remote") == 1,
-- 	config = require("tool.fcitx5"),
-- }
tool["Bekaboo/dropbar.nvim"] = {
	lazy = false,
	config = require("tool.dropbar"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
-- tool["echasnovski/mini.files"] = {
-- 	lazy = true,
-- 	event = "VeryLazy",
-- 	config = require("tool.mini-files"),
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- }
tool["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
	config = require("tool.nvim-tree"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
tool["folke/snacks.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	opts = snacks_picker_opts,
}
tool["akinsho/toggleterm.nvim"] = {
	lazy = true,
	cmd = {
		"ToggleTerm",
		"ToggleTermSetName",
		"ToggleTermToggleAll",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualSelection",
	},
	config = require("tool.toggleterm"),
}
tool["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tool.trouble"),
}
tool["folke/which-key.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("tool.which-key"),
}
tool["gelguy/wilder.nvim"] = {
	lazy = true,
	event = "CmdlineEnter",
	config = require("tool.wilder"),
	dependencies = "romgrk/fzy-lua-native",
}
----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
tool["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("tool.dap"),
	dependencies = {
		{ "jay-babu/mason-nvim-dap.nvim" },
		{
			"rcarriga/nvim-dap-ui",
			dependencies = "nvim-neotest/nvim-nio",
			config = require("tool.dap.dapui"),
		},
	},
}

return tool
