local bind = require("pure-nvim.keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local ts_to_select = require("nvim-treesitter-textobjects.select")
local ts_to_swap = require("nvim-treesitter-textobjects.swap")
local ts_to_move = require("nvim-treesitter-textobjects.move")
local ts_to_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

local mappings = {
	builtins = {
		-- Builtins: Save & Quit
		["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("edit: Save file"),
		["n|<C-q>"] = map_cr("wq"):with_desc("edit: Save file and quit"),
		["n|<A-S-q>"] = map_cr("q!"):with_desc("edit: Force quit"),

		-- Builtins: Insert mode
		["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("edit: Delete previous block"),
		["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Move cursor to left"),
		["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("edit: Move cursor to line start"),
		["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("edit: Save file"),
		["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("edit: Save file and quit"),

		-- Builtins: Command mode
		["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("edit: Left"),
		["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("edit: Right"),
		["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("edit: Home"),
		["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("edit: End"),
		["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("edit: Delete"),
		["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("edit: Backspace"),
		["c|<C-v>"] = map_cmd("<C-R>+"):with_noremap():with_desc("edit: Paste clipboard"),
		["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
			:with_noremap()
			:with_desc("edit: Complete path of current file"),

		-- Builtins: Visual mode
		["v|J"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("edit: Move this line down"),
		["v|K"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("edit: Move this line up"),
		["v|<"] = map_cmd("<gv"):with_desc("edit: Decrease indent"),
		["v|>"] = map_cmd(">gv"):with_desc("edit: Increase indent"),
		["x|<A-/>"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_desc("edit: Toggle line comment"),
		["x|<A-F12>/"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_desc("edit: Toggle line comment"),

		-- Builtins: "Suckless" - named after r/suckless
		["n|Y"] = map_cmd("y$"):with_desc("edit: Yank text to EOL"),
		["n|D"] = map_cmd("d$"):with_desc("edit: Delete text to EOL"),
		["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("edit: Next search result"),
		["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("edit: Prev search result"),
		["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("edit: Join next line"),
		["n|<Esc>"] = map_callback(function()
				local flash_active, state = pcall(function()
					return require("flash.plugins.char").state
				end)
				if flash_active and state then
					state:hide()
				else
					pcall(vim.cmd.noh)
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("edit: Clear search highlight"),
		["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("edit: Toggle spell check"),
		["n|<A-/>"] = map_cmd("<Plug>(comment_toggle_linewise_current)")
			:with_silent()
			:with_desc("edit: Toggle line comment"),
		["n|<A-F12>/"] = map_cmd("<Plug>(comment_toggle_linewise_current)")
			:with_silent()
			:with_desc("edit: Toggle line comment"),
	},
	plugins = {
		-- Plugin: persisted.nvim
		["n|<leader>ss"] = map_cu("Persisted save"):with_noremap():with_silent():with_desc("session: Save"),
		["n|<leader>sl"] = map_cu("Persisted load"):with_noremap():with_silent():with_desc("session: Load current"),
		["n|<leader>sd"] = map_cu("Persisted delete_current"):with_noremap():with_silent():with_desc("session: Delete"),

		-- Plugin: comment.nvim
		["n|gcc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
					or et("<Plug>(comment_toggle_linewise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("edit: Toggle comment for line"),
		["n|gbc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
					or et("<Plug>(comment_toggle_blockwise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("edit: Toggle comment for block"),
		["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for line with operator"),
		["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for block with operator"),
		["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for line with selection"),
		["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("edit: Toggle comment for block with selection"),

		-- Plugin: flash.nvim
		["nxo|s"] = map_callback(function()
				require("flash").jump()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("flash: Jump"),
		["nxo|S"] = map_callback(function()
				require("flash").treesitter()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("flash: Treesitter"),
		["o|r"] = map_callback(function()
				require("flash").remote()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("flash: Remote"),
		["ox|R"] = map_callback(function()
				require("flash").treesitter_search()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("flash: Treesitter Search"),
		["c|<C-s>"] = map_callback(function()
				require("flash").toggle()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("flash: Toggle Search"),

		["nv|<leader>w"] = map_callback(function()
				require("flash").jump({
					search = {
						mode = function(str)
							return "\\<" .. str
						end,
					},
				})
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Goto word"),
		["nv|<leader>j"] = map_callback(function()
				require("flash").jump({
					search = { mode = "search", max_length = 0 },
					label = { after = { 0, 0 } },
					pattern = "^",
				})
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Goto line"),
		["nv|<leader>k"] = map_callback(function()
				require("flash").jump({
					search = { mode = "search", max_length = 0 },
					label = { after = { 0, 0 } },
					pattern = "^",
				})
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Goto line"),
		["nv|<leader>c"] = map_callback(function()
				require("flash").jump()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Goto chars"),
		["nv|<leader>C"] = map_callback(function()
				require("flash").jump()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Goto chars"),

		-- Plugin: grug-far
		["n|<leader>Ss"] = map_callback(function()
				require("grug-far").open()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: Toggle search & replace panel"),
		["n|<leader>Sp"] = map_callback(function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: search&replace current word (project)"),
		["v|<leader>Sp"] = map_callback(function()
				require("grug-far").with_visual_selection()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("edit: search & replace current word (project)"),
		["n|<leader>Sf"] = map_callback(function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: search & replace current word (file)"),

		["o|m"] = map_callback(function()
				require("flash").treesitter()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("jump: Operate across syntax tree"),

		-- Plugin: suda.vim
		["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("editn: Save file using sudo"),

		-- Plugin: nvim-treesitter-textobjects
		-- Text objects: select
		["xo|af"] = map_callback(function()
				ts_to_select.select_textobject("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editxo: Select function.outer"),
		["xo|if"] = map_callback(function()
				ts_to_select.select_textobject("@function.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editxo: Select function.inner"),
		["xo|ac"] = map_callback(function()
				ts_to_select.select_textobject("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editxo: Select class.outer"),
		["xo|ic"] = map_callback(function()
				ts_to_select.select_textobject("@class.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editoxo: Select class.inner"),
		-- Text objects: swap
		["n|<leader>a"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.inner")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: Swap parameter.inner"),
		["n|<leader>A"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.outer")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editn: Swap parameter.outer"),
		-- Text objects: move
		["nxo|]["] = map_callback(function()
				ts_to_move.goto_next_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to next function.outer start"),
		["nxo|]m"] = map_callback(function()
				ts_to_move.goto_next_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to next class.outer start"),
		["nxo|]]"] = map_callback(function()
				ts_to_move.goto_next_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to next function.outer end"),
		["nxo|]M"] = map_callback(function()
				ts_to_move.goto_next_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to next class.outer end"),
		["nxo|[["] = map_callback(function()
				ts_to_move.goto_previous_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to previous function.outer start"),
		["nxo|[m"] = map_callback(function()
				ts_to_move.goto_previous_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to previous class.outer start"),
		["nxo|[]"] = map_callback(function()
				ts_to_move.goto_previous_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to previous function.outer end"),
		["nxo|[M"] = map_callback(function()
				ts_to_move.goto_previous_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Move to previous class.outer end"),
		-- movements repeat
		["nxo|;"] = map_callback(function()
				ts_to_repeat_move.repeat_last_move_next()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("editnxo: Repeat last move"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)
