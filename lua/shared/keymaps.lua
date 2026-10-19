local M = {}

function M.setup()
	if M.loaded then
		return
	end
	M.loaded = true

	local i18n = require("shared.i18n")
	local windows = require("shared.windows")

	vim.keymap.set({ "i", "n", "s" }, "<Esc>", function()
		vim.cmd("noh")
		return "<Esc>"
	end, { expr = true, desc = i18n.t("escape_and_clear_search") })

	vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true })
	vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true })

	vim.api.nvim_create_autocmd("TermOpen", {
		callback = function(args)
			vim.keymap.set("n", "j", "j", { buffer = args.buf, noremap = true })
			vim.keymap.set("n", "k", "k", { buffer = args.buf, noremap = true })
		end,
	})

	vim.keymap.set({ "n", "v" }, "H", "^", { desc = i18n.t("go_to_start_of_line") })
	vim.keymap.set({ "n", "v" }, "L", "$", { desc = i18n.t("go_to_end_of_line") })

	vim.keymap.set("i", "jk", "<Esc>", { desc = i18n.t("exit_insert_mode") })
	vim.keymap.set("i", "kj", "<Esc>", { desc = i18n.t("exit_insert_mode") })

	vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste clipboard", noremap = true })
	vim.keymap.set("c", "<C-v>", "<C-r>+", { desc = "Paste clipboard", noremap = true })

	vim.keymap.set("n", "p", "P", { desc = "Paste before cursor (preserve register)", noremap = true })
	vim.keymap.set("v", "p", "P", { desc = "Paste before cursor (preserve register)", noremap = true })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "snacks_picker_input" },
		callback = function()
			vim.keymap.set("i", "<C-v>", function()
				vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
			end, { buffer = 0, desc = "Paste clipboard in picker" })
		end,
	})

	-- 在特定 buffer 的 normal 模式下添加 Ctrl+C 映射为 Esc
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"minifiles",
			"trouble",
			"TelescopePrompt",
			"lazy",
			"mason",
			"snacks_notifier",
			"snacks_dashboard",
			"snacks_terminal",
		},
		callback = function()
			vim.keymap.set("n", "<C-c>", "<Esc>", { buffer = 0, desc = "Close panel" })
		end,
	})

	vim.keymap.set("n", "<C-CR>", "o<Esc>", { desc = i18n.t("add_empty_line_below"), silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"\x1b[13;5u",
		"o<Esc>",
		{ noremap = true, silent = true, desc = i18n.t("add_empty_line_below_win") }
	)

	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = i18n.t("focus_left_window"), remap = true })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = i18n.t("focus_right_window"), remap = true })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = i18n.t("focus_down_window"), remap = true })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = i18n.t("focus_up_window"), remap = true })

	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = i18n.t("exit_terminal_mode") })

	vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = i18n.t("open_diagnostic_quickfix") })

	vim.keymap.set("n", "<leader>qq", "<Cmd>qa!<CR>", { desc = i18n.t("quit_all") })

	vim.keymap.set("n", "<leader>ta", function()
		require("shared.i18n").toggle_lang()
	end, { desc = i18n.t("toggle_language") })

	if not vim.g.vscode then
		vim.keymap.set("n", "<leader>O1", windows.open_in_system_explorer, { desc = i18n.t("open_in_system_explorer") })
		vim.keymap.set("n", "<leader>O2", windows.open_in_wsl_explorer, { desc = i18n.t("open_in_wsl_explorer") })
		vim.keymap.set("n", "<leader>O3", windows.open_image_in_windows, { desc = i18n.t("open_image_in_windows") })
	end

	local function copy_to_clipboard(text, description)
		require("shared.clipboard").copy(text)
		if description then
			vim.notify(description, vim.log.levels.INFO)
		end
	end

	vim.keymap.set("n", "<leader>rr", function()
		local absolute_path
		-- 检测是否在 nvim-tree 中
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		if filetype == "NvimTree" then
			-- 使用 nvim-tree API 获取节点路径
			local api = require("nvim-tree.api")
			local node = api.tree.get_node_under_cursor()
			absolute_path = node.absolute_path
		else
			-- 普通文件使用原逻辑
			absolute_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
		end
		copy_to_clipboard(absolute_path)
	end, { desc = i18n.t("copy_relative_path_absolute") })

	vim.keymap.set("n", "<leader>rd", function()
		local dir_path
		-- 检测是否在 nvim-tree 中
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		if filetype == "NvimTree" then
			-- 使用 nvim-tree API 获取节点路径
			local api = require("nvim-tree.api")
			local node = api.tree.get_node_under_cursor()
			-- 如果是目录，使用目录路径；如果是文件，使用父目录路径
			dir_path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
		else
			-- 普通文件使用原逻辑
			dir_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
		end
		copy_to_clipboard(dir_path, "Copied directory path: " .. dir_path)
	end, { desc = i18n.t("copy_directory_path") })
end

return M
