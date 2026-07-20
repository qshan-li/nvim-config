vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(args)
		vim.keymap.set("n", "<F1>", "<Cmd>RenderMarkdown toggle<CR>", {
			buffer = args.buf,
			noremap = true,
			silent = true,
			desc = "tool: toggle markdown preview within nvim",
		})
		vim.keymap.set("n", "<F12>", "<Cmd>MarkdownPreviewToggle<CR>", {
			buffer = args.buf,
			noremap = true,
			silent = true,
			desc = "tool: Preview markdown",
		})
	end,
})
