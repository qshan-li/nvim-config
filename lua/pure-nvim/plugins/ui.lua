local ui = {}

ui["eoh-bse/minintro.nvim"] = {
	lazy = false,
	opts = { color = "#86A7A0" },
	config = require("ui.minintro"),
}
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPre", "BufAdd", "BufNewFile" },
	cmd = {
		"BufferLineCyclePrev",
		"BufferLineCycleNext",
		"BufferLineMoveNext",
		"BufferLineMovePrev",
		"BufferLineSortByExtension",
		"BufferLineSortByDirectory",
		"BufferLineGoToBuffer",
	},
	config = require("ui.bufferline"),
}
ui["rose-pine/neovim"] = {
	lazy = false,
	name = "rose-pine",
	config = require("ui.rose-pine"),
}
ui["qshan-li/neovim-theme-vitesse"] = {
	lazy = false,
	priority = 1000,
	config = require("ui.vitesse"),
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = require("ui.gitsigns"),
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = require("ui.indent-blankline"),
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.lualine"),
}
ui["nvim-mini/mini.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("ui.notify"),
}
ui["folke/paint.nvim"] = {
	lazy = true,
	ft = { "lua", "python" },
	config = require("ui.paint"),
}
ui["mrjones2014/smart-splits.nvim"] = {
	lazy = true,
	cmd = {
		"SmartResizeLeft",
		"SmartResizeRight",
		"SmartResizeUp",
		"SmartResizeDown",
		"SmartCursorMoveLeft",
		"SmartCursorMoveRight",
		"SmartCursorMoveUp",
		"SmartCursorMoveDown",
		"SmartSwapLeft",
		"SmartSwapRight",
		"SmartSwapUp",
		"SmartSwapDown",
	},
	config = require("ui.splits"),
}
ui["folke/edgy.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("ui.edgy"),
}
ui["folke/todo-comments.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = require("ui.todo"),
	dependencies = "nvim-lua/plenary.nvim",
}
return ui
