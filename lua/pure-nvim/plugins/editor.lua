local editor = {}

editor["olimorris/persisted.nvim"] = {
	lazy = false,
	config = require("editor.persisted"),
}
editor["m4xshen/autoclose.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("editor.autoclose"),
}
editor["pteroctopus/faster.nvim"] = {
	lazy = false,
	cond = require("pure-nvim.core.settings").load_big_files_faster,
	config = require("editor.faster"),
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
editor["folke/flash.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("editor.flash"),
}
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = require("editor.comment"),
}
editor["echasnovski/mini.align"] = {
	lazy = true,
	keys = { "gea", "geA" },
	config = require("editor.align"),
}
editor["echasnovski/mini.cursorword"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("editor.cursorword"),
}
editor["brenoprata10/nvim-highlight-colors"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = require("editor.highlight-colors"),
}
editor["romainl/vim-cool"] = {
	lazy = true,
	event = { "CursorMoved", "InsertEnter" },
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	init = require("editor.suda"),
}
editor["tpope/vim-sleuth"] = {
	lazy = true,
	event = { "BufNewFile", "BufReadPost", "BufFilePost" },
}
editor["MagicDuck/grug-far.nvim"] = {
	lazy = true,
	cmd = "GrugFar",
	config = require("editor.grug-far"),
}
----------------------------------------------------------------------
--                  :treesitter related plugins                    --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = false, -- nvim-ts cannot lazy load now
	config = require("editor.treesitter"),
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = require("editor.ts-textobjects"),
		},
		{
			"andymass/vim-matchup",
			init = require("editor.matchup"),
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("editor.autotag"),
		},
		{
			"hiphish/rainbow-delimiters.nvim",
			submodules = false,
			config = require("editor.rainbow_delims"),
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = require("editor.ts-context"),
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			config = require("editor.ts-context-commentstring"),
		},
	},
}

return editor
