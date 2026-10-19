-- 使用 mason 的 html-lsp（vscode-html-language-server），不要覆盖 cmd
return {
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
	},
	flags = { debounce_text_changes = 500 },
	single_file_support = true,
	settings = {},
}
