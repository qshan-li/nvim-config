local completion = {}

completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = require("completion.lsp"),
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
		{ "folke/neoconf.nvim" },
	},
}
completion["rachartier/tiny-code-action.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.tiny-code-action"),
}
completion["smjonas/inc-rename.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.inc-rename"),
}
completion["DNLHC/glance.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("completion.glance"),
}
completion["dmmulroy/ts-error-translator.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = function()
		require("ts-error-translator").setup()
	end,
}
completion["rachartier/tiny-inline-diagnostic.nvim"] = {
	lazy = false,
	config = require("completion.tiny-inline-diagnostic"),
}
completion["stevearc/conform.nvim"] = {
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = require("completion.conform"),
}
completion["WhoIsSethDaniel/mason-tool-installer.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = require("pure-nvim.core.settings").mason_tools,
		})
	end,
	dependencies = { "mason-org/mason.nvim" },
}
completion["monkoose/neocodeium"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("completion.neocodeium"),
}
completion["hrsh7th/nvim-cmp"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("completion.cmp"),
	dependencies = {
		{ "lukas-reineke/cmp-under-comparator" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path" },
		{ "f3fora/cmp-spell" },
		{ "hrsh7th/cmp-buffer" },
	},
}

return completion
