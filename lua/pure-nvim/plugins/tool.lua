local tool = {}

-- This is specifically for fcitx5 users who code in languages other than English
tool["pysan3/fcitx5.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	cond = vim.fn.executable("fcitx5-remote") == 1,
	config = require("tool.fcitx5"),
}
tool["Bekaboo/dropbar.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
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
