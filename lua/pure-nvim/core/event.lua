-- Now use `<A-o>` or `<A-1>` to go back to the `dotstutor`.
local autocmd = {}

-- Autoclose nvim-tree
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NvimTreeAutoClose", { clear = true }),
	pattern = "NvimTree_*",
	callback = function()
		require("pure-nvim.utils.landing").recover_from_lonely_tree()
	end,
})

-- Autoclose some filetype with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"nofile",
		"terminal",
		"prompt",
		"toggleterm",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<Cmd>close<CR>", { silent = true })

		if event.match == "qf" then
			vim.keymap.set("n", "<CR>", function()
				local current_line = vim.fn.line(".")
				local current_window = vim.api.nvim_get_current_win()
				local current_window_info = vim.fn.getwininfo(current_window)[1]
				local is_location_list = current_window_info ~= nil and current_window_info.loclist == 1

				if is_location_list then
					vim.cmd("ll " .. current_line)
				else
					vim.cmd("cc " .. current_line)
				end

				pcall(vim.cmd, "lclose")
				pcall(vim.cmd, "cclose")
			end, { buffer = event.buf, silent = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "vue",
	callback = function(args)
		vim.b[args.buf].matchup_treesitter_enabled = false
		vim.b[args.buf].matchup_matchparen_enabled = 0
		vim.b[args.buf].matchup_matchparen_fallback = 0

		local ok, rainbow_delimiters = pcall(require, "rainbow-delimiters")
		if ok then
			rainbow_delimiters.disable(args.buf)
		end
	end,
})

-- Hold off on configuring anything related to the LSP until LspAttach
local mapping = require("pure-nvim.keymap.completion")
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymapLoader", { clear = true }),
	callback = function(event)
		if not _G._debugging then
			-- LSP Keymaps
			mapping.lsp(event.buf)

			-- LSP Inlay Hints
			local inlayhints_enabled = require("pure-nvim.core.settings").lsp_inlayhints
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.inlayHintProvider ~= nil then
				vim.lsp.inlay_hint.enable(inlayhints_enabled == true, { bufnr = event.buf })
			end
		end
	end,
})

-- Start treesitter for installed parsers
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		-- Filetypes and parser names are not always identical, so starting by parser-name patterns
		-- misses valid buffers like `help` -> `vimdoc`. Let Neovim resolve the parser per buffer instead.
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Autojump to last edit
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

function autocmd.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		-- Prepend an underscore to avoid name clashes
		vim.api.nvim_command("augroup _" .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.iter({ "autocmd", def }):flatten(math.huge):totable(), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

function autocmd.load_autocmds()
	local definitions = {
		bufs = {
			-- Reload vim config automatically
			{
				"BufWritePost",
				[[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
			},
			-- Reload Vim script automatically if setlocal autoread
			{
				"BufWritePost,FileWritePost",
				"*.vim",
				[[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
			},
			{ "BufWritePre", "*~", "setlocal noundofile" },
			{ "BufWritePre", "/tmp/*", "setlocal noundofile" },
			{ "BufWritePre", "*.tmp", "setlocal noundofile" },
			{ "BufWritePre", "*.bak", "setlocal noundofile" },
			{ "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
			{ "BufWritePre", "description", "setlocal noundofile" },
			{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
			-- Auto change directory
			-- { "BufEnter", "*", "silent! lcd %:p:h" },
			-- Auto toggle fcitx5
			-- {"InsertLeave", "* :silent", "!fcitx5-remote -c"},
			-- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
			-- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
			-- {"BufLeave", "*", ":silent !fcitx5-remote -c "}
		},
		wins = {
			-- Highlight current line only in focused window
			{
				"WinEnter,BufEnter,InsertLeave",
				"*",
				[[if ! &cursorline && &filetype !~# '^\(minintro\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
			},
			{
				"WinLeave,BufLeave,InsertEnter",
				"*",
				[[if &cursorline && &filetype !~# '^\(minintro\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
			},
			-- Attempt to write shada when leaving nvim
			{
				"VimLeave",
				"*",
				[[if has('nvim') | wshada | else | wviminfo! | endif]],
			},
			-- Check if a file has changed when its window is in focus, being more proactive than 'autoread'
			{ "FocusGained", "*", "checktime" },
			-- Maintain uniform window dimensions when resizing Vim windows
			{ "VimResized", "*", [[tabdo wincmd =]] },
		},
		ft = {
			{ "FileType", "*", "setlocal formatoptions-=cro" },
			{ "FileType", "minintro", "setlocal showtabline=0" },
			{ "FileType", "markdown", "setlocal wrap" },
			{ "FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()" },
		},
		yank = {
			{
				"TextYankPost",
				"*",
				[[silent! lua vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 })]],
			},
		},
	}

	autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
