local M = {}

function M.setup()
	if M.loaded then
		return
	end
	M.loaded = true

	local vscode = require("vscode")
	local i18n = require("shared.i18n")
	local map = vim.keymap.set

	map("n", "<leader> ", function()
		vscode.action("workbench.action.showCommands")
	end, { desc = i18n.t("show_all_commands") })
	map("n", "<leader>,", function()
		vscode.action("workbench.action.openGlobalSettings")
	end, { desc = i18n.t("settings") })
	map("n", "<leader>Q", function()
		vscode.action("workbench.action.closeWindow")
	end, { desc = i18n.t("close_window") })
	map("n", "<leader>q", function()
		vscode.action("workbench.action.closeActiveEditor")
	end, { desc = i18n.t("close_editor") })
	map("n", "<leader>r", function()
		vscode.action("workbench.action.openRecent")
	end, { desc = i18n.t("recent_files") })
	map("n", "<leader>/", function()
		vscode.action("workbench.action.splitEditorDown")
	end, { desc = i18n.t("split_horizontal") })
	map("n", "<leader>\\", function()
		vscode.action("workbench.action.splitEditorRight")
	end, { desc = i18n.t("split_vertical") })
	map("n", "<leader>bn", function()
		vscode.action("workbench.action.files.newUntitledFile")
	end, { desc = i18n.t("buffer_new") })

	map("n", "<leader>ff", function()
		vscode.action("workbench.action.quickOpen")
	end, { desc = i18n.t("find_file") })
	map("n", "<leader>fw", function()
		vscode.action("search.action.openEditor")
	end, { desc = i18n.t("new_search_editor") })
	map("n", "<leader>fs", function()
		vscode.action("workbench.view.search")
	end, { desc = i18n.t("search_text") })
	map("n", "<leader>Ss", function()
		vscode.action("workbench.action.replaceInFiles")
	end, { desc = i18n.t("search_replace_all") })
	map("n", "<leader>Sp", function()
		vscode.action("workbench.action.findInFiles", { query = vim.fn.expand("<cword>") })
	end, { desc = i18n.t("search_cursor_word") })
	map("n", "<leader>fm", function()
		vscode.action("workbench.action.openGlobalKeybindings")
	end, { desc = i18n.t("keyboard_shortcuts") })

	map("n", "<leader>O1", function()
		vscode.action("revealFileInOS")
	end, { desc = i18n.t("open_in_system_explorer") })
	map("n", "<leader>O2", function()
		vscode.action("remote-wsl.revealInExplorer")
	end, { desc = i18n.t("open_in_wsl_explorer") })

	map("n", "<leader>[", function()
		vscode.action("editor.foldAll")
	end, { desc = i18n.t("fold_all") })
	map("n", "<leader>]", function()
		vscode.action("editor.unfoldAll")
	end, { desc = i18n.t("unfold_all") })
	map("n", "za", function()
		vscode.action("editor.toggleFold")
	end, { desc = i18n.t("toggle_code_fold") })

	map("n", "<C-/>", function()
		vscode.action("editor.action.commentLine")
	end, { desc = i18n.t("toggle_line_comment") })
	map("v", "<C-/>", function()
		vscode.action("editor.action.commentLine")
	end, { desc = i18n.t("toggle_line_comment") })

	-- n/N 搜索结果居中，对齐纯 Neovim 侧（zz 由扩展同步滚动）
	map("n", "n", "nzzzv", { desc = i18n.t("next_search_result"), noremap = true, silent = true })
	map("n", "N", "Nzzzv", { desc = i18n.t("prev_search_result"), noremap = true, silent = true })

	-- gc/gb 注释操作符，对齐纯 Neovim 侧 Comment.nvim 键位（to_op 映射必须 expr）
	local function feed_esc()
		local key = vim.api.nvim_replace_termcodes("<esc>", true, true, true)
		vim.api.nvim_feedkeys(key, "n", false)
	end
	local comment_op = vscode.to_op(function(ctx)
		local cmd = ctx.is_linewise and "editor.action.commentLine" or "editor.action.blockComment"
		local opts = { range = ctx.range, callback = feed_esc }
		if ctx.is_linewise and ctx.is_current_line then
			opts.range = nil
		end
		vscode.action(cmd, opts)
	end)
	local comment_block_op = vscode.to_op(function(ctx)
		vscode.action("editor.action.blockComment", { range = ctx.range, callback = feed_esc })
	end)
	local function comment_line_now()
		return comment_op() .. "_"
	end
	local function comment_block_now()
		return comment_block_op() .. "_"
	end
	map({ "n", "x" }, "gc", comment_op, { expr = true, desc = i18n.t("toggle_line_comment") })
	map("n", "gcc", comment_line_now, { expr = true, desc = i18n.t("toggle_line_comment") })
	map({ "n", "x" }, "gb", comment_block_op, { expr = true, desc = i18n.t("toggle_block_comment") })
	map("n", "gbc", comment_block_now, { expr = true, desc = i18n.t("toggle_block_comment") })

	map("n", "<leader>rr", function()
		vscode.action("workbench.action.files.copyPathOfActiveFile")
	end, { desc = i18n.t("copy_file_path") })
	map("n", "<leader>rd", function()
		vscode.action("workbench.action.files.copyActiveFileParentFolder")
	end, { desc = i18n.t("copy_folder_path") })
end

return M
