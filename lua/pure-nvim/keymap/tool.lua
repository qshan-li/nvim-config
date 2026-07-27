local bind = require("pure-nvim.keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local _lazygit = nil

local panel_terms = {}
local panel_term_names = {}
local current_panel_term_id = 1

local function ensure_panel_term(id)
	local term = panel_terms[id]
	if term then
		return term
	end

	local name = panel_term_names[id] or ("Terminal " .. id)
	panel_term_names[id] = name
	local Terminal = require("toggleterm.terminal").Terminal
	term = Terminal:new({ direction = "horizontal", hidden = true, display_name = name })
	panel_terms[id] = term
	return term
end

local function open_panel_term(id)
	current_panel_term_id = id
	local term = ensure_panel_term(id)

	for idx, other in pairs(panel_terms) do
		if idx ~= id and other:is_open() then
			other:close()
		end
	end

	term:toggle()
end

local function toggle_panel_term()
	open_panel_term(current_panel_term_id)
end

local function next_panel_term_id()
	local ids = vim.tbl_keys(panel_term_names)
	table.sort(ids)
	if #ids == 0 then
		return 1
	end
	for i, id in ipairs(ids) do
		if id == current_panel_term_id then
			return ids[(i % #ids) + 1]
		end
	end
	return ids[1]
end

local function prev_panel_term_id()
	local ids = vim.tbl_keys(panel_term_names)
	table.sort(ids)
	if #ids == 0 then
		return 1
	end
	for i, id in ipairs(ids) do
		if id == current_panel_term_id then
			return ids[((i - 2) % #ids) + 1]
		end
	end
	return ids[1]
end

local function new_panel_term(start_in_normal)
	local id = 1
	while panel_term_names[id] do
		id = id + 1
	end
	open_panel_term(id)
	vim.schedule(function()
		if start_in_normal then
			vim.cmd("stopinsert")
		else
			vim.cmd("startinsert")
		end
	end)
	return id
end

local function rename_panel_term()
	local id = current_panel_term_id
	local current = panel_term_names[id] or ("Terminal " .. id)
	vim.ui.input({ prompt = "Rename terminal:", default = current }, function(name)
		if not name or name == "" then
			return
		end
		panel_term_names[id] = name
		local term = panel_terms[id]
		if term then
			term.display_name = name
		end
	end)
end

local function kill_panel_term(id)
	local term = panel_terms[id]
	panel_terms[id] = nil
	panel_term_names[id] = nil
	if not term then
		return
	end
	term:shutdown()
	if current_panel_term_id == id then
		current_panel_term_id = next_panel_term_id()
	end
end

local function next_terminal_instance()
	if vim.bo.buftype ~= "terminal" then
		return
	end
	if vim.tbl_count(panel_term_names) > 1 then
		return open_panel_term(next_panel_term_id())
	end

	local toggleterm_lib = require("toggleterm.terminal")
	local terms = toggleterm_lib.get_all()
	if #terms == 0 then
		return
	end
	local current_id = toggleterm_lib.get_focused_id() or 0
	local next_id = current_id + 1
	if next_id > #terms then
		next_id = 1
	end
	require("toggleterm").toggle(next_id, nil, nil, "horizontal")
end

local function prev_terminal_instance()
	if vim.bo.buftype ~= "terminal" then
		return
	end
	if vim.tbl_count(panel_term_names) > 1 then
		return open_panel_term(prev_panel_term_id())
	end

	local toggleterm_lib = require("toggleterm.terminal")
	local terms = toggleterm_lib.get_all()
	if #terms == 0 then
		return
	end
	local current_id = toggleterm_lib.get_focused_id() or 1
	local prev_id = current_id - 1
	if prev_id < 1 then
		prev_id = #terms
	end
	require("toggleterm").toggle(prev_id, nil, nil, "horizontal")
end

local function pick_panel_term()
	require("snacks").picker.pick({
		source = "terminals",
		title = "Terminals",
		format = "text",
		finder = function()
			local items = { { id = -1, text = "+ New terminal" } }
			local ids = vim.tbl_keys(panel_term_names)
			table.sort(ids)
			for _, id in ipairs(ids) do
				table.insert(items, { id = id, text = panel_term_names[id] })
			end
			return items
		end,
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			if item.id == -1 then
				new_panel_term()
			else
				open_panel_term(item.id)
			end
		end,
		actions = {
			kill_terminal = function(picker)
				local item = picker:current()
				if not item or not item.id or item.id == -1 then
					return
				end
				kill_panel_term(item.id)
				picker:find()
			end,
		},
		win = {
			input = {
				keys = {
					["<C-d>"] = { "kill_terminal", mode = { "n", "i" }, desc = "Kill terminal" },
				},
			},
			list = {
				keys = {
					["d"] = "kill_terminal",
				},
			},
		},
	})
end

local function open_split_term(start_in_normal)
	local Terminal = require("toggleterm.terminal").Terminal
	Terminal:new({ direction = "horizontal", hidden = true }):toggle()
	vim.schedule(function()
		if start_in_normal then
			vim.cmd("stopinsert")
		else
			vim.cmd("startinsert")
		end
	end)
end

local function new_terminal_instance(start_in_normal)
	if vim.bo.buftype ~= "terminal" then
		return
	end
	if vim.tbl_count(panel_term_names) > 0 then
		new_panel_term(start_in_normal)
		return
	end
	open_split_term(start_in_normal)
end

local function close_current_terminal()
	if vim.bo.buftype ~= "terminal" then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	for panel_id, term in pairs(panel_terms) do
		if term and term.bufnr == bufnr then
			kill_panel_term(panel_id)
			return
		end
	end

	local ok, toggleterm_lib = pcall(require, "toggleterm.terminal")
	if ok and (vim.bo.filetype == "toggleterm" or vim.b.toggle_number ~= nil) then
		local id = vim.b.toggle_number or toggleterm_lib.get_focused_id()
		if id then
			local term = toggleterm_lib.get(id, true)
			if term then
				term:shutdown()
				return
			end
		end
	end

	vim.cmd("bdelete!")
end

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("terminal_keymaps", { clear = false }),
	callback = function(args)
		vim.keymap.set({ "n", "t" }, "<C-n>", function()
			new_terminal_instance(false)
		end, { buffer = args.buf, desc = "terminal: New terminal" })
	end,
})

local mappings = {
	plugins = {
		["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),

		["n|E"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("filetree: Find file"),

		["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(),
		["n|<C-\\>"] = map_cr("ToggleTerm direction=horizontal")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle horizontal"),
		["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle horizontal"),
		["t|<C-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle horizontal"),
		["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle vertical"),
		["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle vertical"),
		["t|<A-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle vertical"),
		["n|<F5>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle vertical"),
		["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle vertical"),
		["t|<F5>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
		["n|<A-d>"] = map_cr("ToggleTerm direction=float")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle float"),
		["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle float"),
		["t|<A-d>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
		["n|<leader>gg"] = map_callback(function()
				if vim.fn.executable("lazygit") == 1 then
					local Terminal = require("toggleterm.terminal").Terminal
					if not _lazygit then
						_lazygit = Terminal:new({
							cmd = "lazygit",
							direction = "float",
							close_on_exit = true,
							hidden = true,
						})
					end
					_lazygit:toggle()
				else
					vim.notify("Command [lazygit] not found!", vim.log.levels.ERROR, { title = "toggleterm.nvim" })
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("git: Toggle lazygit"),

		["n|gt"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Toggle trouble list"),
		["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show workspace diagnostics"),
		["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show project diagnostics"),
		["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Show document diagnostics"),

		["n|<C-p>"] = map_callback(function()
				toggle_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle panel"),
		["i|<C-p>"] = map_callback(function()
				vim.cmd("stopinsert")
				toggle_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle panel"),
		["t|<C-p>"] = map_callback(function()
				toggle_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle panel"),

		["n|<leader>tt"] = map_callback(function()
				toggle_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Toggle panel"),
		["n|<leader>tn"] = map_callback(function()
				new_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: New terminal"),
		["n|<leader>tp"] = map_callback(function()
				pick_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Pick terminal"),
		["n|<leader>tr"] = map_callback(function()
				rename_panel_term()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Rename terminal"),
		["n|<leader>tq"] = map_callback(function()
				kill_panel_term(current_panel_term_id)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Kill terminal"),
		["n|]T"] = map_callback(function()
				open_panel_term(next_panel_term_id())
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Next panel terminal"),
		["n|[T"] = map_callback(function()
				open_panel_term(prev_panel_term_id())
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Previous panel terminal"),

		-- Alt + 数字键切换终端实例
		["t|<A-1>"] = map_callback(function()
				open_panel_term(1)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 1"),
		["t|<A-2>"] = map_callback(function()
				open_panel_term(2)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 2"),
		["t|<A-3>"] = map_callback(function()
				open_panel_term(3)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 3"),
		["t|<A-4>"] = map_callback(function()
				open_panel_term(4)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 4"),
		["t|<A-5>"] = map_callback(function()
				open_panel_term(5)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 5"),
		["t|<A-6>"] = map_callback(function()
				open_panel_term(6)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 6"),
		["t|<A-7>"] = map_callback(function()
				open_panel_term(7)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 7"),
		["t|<A-8>"] = map_callback(function()
				open_panel_term(8)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 8"),
		["t|<A-9>"] = map_callback(function()
				open_panel_term(9)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Panel 9"),

		["n|<A-F12>h"] = map_callback(function()
				prev_terminal_instance()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Previous terminal"),
		["t|<A-F12>h"] = map_callback(function()
				prev_terminal_instance()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Previous terminal"),
		["n|<A-F12>l"] = map_callback(function()
				next_terminal_instance()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Next terminal"),
		["t|<A-F12>l"] = map_callback(function()
				next_terminal_instance()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Next terminal"),
		["n|<A-F12>\\"] = map_callback(function()
				close_current_terminal()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Close terminal instance"),
		["t|<A-F12>\\"] = map_callback(function()
				close_current_terminal()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Close terminal instance"),

		-- 终端内使用 Ctrl+hjkl 进行焦点移动
		["t|<C-h>"] = map_callback(function()
				require("smart-splits").move_cursor_left()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("window: Focus left"),
		["t|<C-j>"] = map_callback(function()
				require("smart-splits").move_cursor_down()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("window: Focus down"),
		["t|<C-k>"] = map_callback(function()
				require("smart-splits").move_cursor_up()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("window: Focus up"),
		["t|<C-l>"] = map_callback(function()
				require("smart-splits").move_cursor_right()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("window: Focus right"),

		-- Normal 模式下的终端导航
		["n|]t"] = map_callback(function()
				local toggleterm_lib = require("toggleterm.terminal")
				local terms = toggleterm_lib.get_all()
				if #terms == 0 then
					return
				end
				local current_id = toggleterm_lib.get_focused_id() or 0
				local next_id = current_id + 1
				if next_id > #terms then
					next_id = 1
				end
				require("toggleterm").toggle(next_id, nil, nil, "horizontal")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Next terminal"),
		["n|[t"] = map_callback(function()
				local toggleterm_lib = require("toggleterm.terminal")
				local terms = toggleterm_lib.get_all()
				if #terms == 0 then
					return
				end
				local current_id = toggleterm_lib.get_focused_id() or 1
				local prev_id = current_id - 1
				if prev_id < 1 then
					prev_id = #terms
				end
				require("toggleterm").toggle(prev_id, nil, nil, "horizontal")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("terminal: Previous terminal"),
		["n|<C-Tab>"] = map_callback(function()
				local listed_buffers = {}
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if
						vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
					then
						table.insert(listed_buffers, bufnr)
					end
				end
				if #listed_buffers > 1 then
					require("snacks").picker.buffers()
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Switch buffer"),
		["n|\x1b[9;5u"] = map_callback(function()
				local listed_buffers = {}
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if
						vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
					then
						table.insert(listed_buffers, bufnr)
					end
				end
				if #listed_buffers > 1 then
					require("snacks").picker.buffers()
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Switch buffer (terminal)"),
		["n|<leader>fc"] = map_callback(function()
				require("snacks").picker.pickers()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Open Pickers collections"),
		["n|<leader>ff"] = map_callback(function()
				require("snacks").picker.smart({ sources = { files = { hidden = true } } })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find files"),
		["n|<leader>fp"] = map_callback(function()
				require("snacks").picker.grep()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find patterns"),
		["v|<leader>fs"] = map_callback(function()
				require("snacks").picker.grep_word()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Find word under cursor"),
		["n|<leader>fg"] = map_callback(function()
				require("snacks").picker.git_status()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Git status"),
		["n|<leader>fd"] = map_callback(function()
				require("snacks").picker.diagnostics()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Diagnostics"),
		["n|<leader>fm"] = map_callback(function()
				require("snacks").picker.keymaps()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Keymaps"),
		["n|<leader>fR"] = map_callback(function()
				require("snacks").picker.resume()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Resume last search"),
		["n|<leader>th"] = map_callback(function()
				local themes = {
					{ name = "rose-pine", display = "Rose Pine (Auto)" },
					{ name = "rose-pine-main", display = "Rose Pine (Main)" },
					{ name = "rose-pine-moon", display = "Rose Pine (Moon)" },
					{ name = "rose-pine-dawn", display = "Rose Pine (Dawn)" },
					{ name = "vitesse", display = "Vitesse (Auto)" },
					{ name = "vitesse-dark", display = "Vitesse (Dark)" },
					{ name = "vitesse-light", display = "Vitesse (Light)" },
					{ name = "vitesse-black", display = "Vitesse (Black)" },
				}

				vim.ui.select(themes, {
					prompt = "Select theme",
					format_item = function(item)
						return item.display
					end,
				}, function(choice)
					if choice then
						vim.cmd("colorscheme " .. choice.name)
						vim.notify("Theme changed to " .. choice.display, vim.log.levels.INFO)
					end
				end)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("ui: Switch theme"),
		["n|<leader>r"] = map_callback(function()
				local session_dir = vim.fn.stdpath("data") .. "/sessions/"
				require("snacks").picker.pick({
					source = "sessions",
					title = "Sessions",
					format = "text",
					finder = function()
						local files = vim.fn.readdir(session_dir)
						local items = {}
						for _, f in ipairs(files) do
							if f:match("%.vim$") then
								local path = session_dir .. f
								local display = f:gsub("%%", "/"):gsub("%.vim$", ""):gsub("@@", "@", 1)
								table.insert(items, { file = path, text = display })
							end
						end
						return items
					end,
					confirm = function(picker, item)
						picker:close()
						if item then
							vim.schedule(function()
								require("persisted").load({ session = item.file })
							end)
						end
					end,
					actions = {
						delete_session = function(picker)
							local item = picker:current()
							if item and item.file then
								vim.ui.select({ "Yes", "No" }, {
									prompt = "Delete session: " .. item.text .. "?",
								}, function(choice)
									if choice == "Yes" then
										vim.fn.delete(item.file)
										picker:find()
									end
								end)
							end
						end,
					},
					win = {
						input = {
							keys = {
								["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete session" },
							},
						},
					},
				})
			end)
			:with_noremap()
			:with_silent()
			:with_desc("tool: Session picker"),

		["n|<F6>"] = map_callback(function()
				require("dap").continue()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Run/Continue"),
		["n|<F7>"] = map_callback(function()
				require("dap").terminate()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Stop"),
		["n|<F8>"] = map_callback(function()
				require("dap").toggle_breakpoint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Toggle breakpoint"),
		["n|<F9>"] = map_callback(function()
				require("dap").step_into()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Step into"),
		["n|<F10>"] = map_callback(function()
				require("dap").step_out()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Step out"),
		["n|<F11>"] = map_callback(function()
				require("dap").step_over()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Step over"),
		["n|<leader>db"] = map_callback(function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Set breakpoint with condition"),
		["n|<leader>dc"] = map_callback(function()
				require("dap").run_to_cursor()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Run to cursor"),
		["n|<leader>dl"] = map_callback(function()
				require("dap").run_last()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Run last"),
		["n|<leader>do"] = map_callback(function()
				require("dap").repl.open()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("debug: Open REPL"),
	},
}

bind.nvim_load_mapping(mappings.plugins)
