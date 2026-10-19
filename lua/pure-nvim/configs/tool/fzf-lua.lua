return function()
	require("fzf-lua").setup({
		winopts = {
			height = 0.85,
			width = 0.85,
			row = 0.35,
			col = 0.5,
			border = "rounded",
			preview = {
				layout = "flex",
				flip_columns = 120,
				vertical = "down:45%",
				horizontal = "right:60%",
				wrap = false,
				hidden = false,
			},
		},
		keymap = {
			builtin = {
				-- 不让 <c-v> 触发分屏，保持终端粘贴行为
				["<c-v>"] = false,
			},
		},
		previewers = {
			builtin = {
				-- 预览不做语法高亮，减少大文件开销
				syntax = false,
				treesitter = { enabled = false },
			},
		},
	})
end
