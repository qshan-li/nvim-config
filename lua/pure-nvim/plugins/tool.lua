local tool = {}

tool["Bekaboo/dropbar.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = require("tool.dropbar"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
tool["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
	config = require("tool.nvim-tree"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
tool["ibhagwan/fzf-lua"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("tool.fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
return tool
