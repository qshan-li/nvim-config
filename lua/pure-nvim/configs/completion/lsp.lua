return function()
	require("completion.neoconf").setup()
	require("completion.mason").setup()
	require("completion.mason-lspconfig").setup()

	local utils = require("pure-nvim.utils")
	-- Start LSPs
	pcall(vim.cmd.LspStart)
end
