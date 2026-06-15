local M = {}

M.lang = "en"
M.available_languages = { "en", "zh" }

M.translations = {
	en = {
		save_file = "Save File",
		windows = "windows",
		git = "Git",
		debug = "Debug",
		session = "Session",
		buffer = "Buffer",
		search = "Search",
		window = "Window",
		package = "Package",
		lsp = "Lsp",
		fuzzy_find = "Fuzzy Find",
		nvim_tree = "Nvim Tree",
		toggle_language = "Toggle Which-Key Language",

		escape_and_clear_search = "Escape and Clear Search",
		go_to_start_of_line = "Go to start of line",
		go_to_end_of_line = "Go to end of line",
		exit_insert_mode = "Exit insert mode",
		add_empty_line_below = "Add empty line below",
		add_empty_line_below_win = "Add empty line below (Windows Terminal)",
		focus_left_window = "Focus left window",
		focus_right_window = "Focus right window",
		focus_down_window = "Focus down window",
		focus_up_window = "Focus up window",
		exit_terminal_mode = "Exit terminal mode",
		open_diagnostic_quickfix = "Open diagnostic Quickfix list",
		copy_relative_path_absolute = "Copy relative path (absolute)",
		copy_directory_path = "Copy directory path",

		next_diagnostic = "Next Diagnostic",
		prev_diagnostic = "Previous Diagnostic",
		toggle_markview = "Toggle Markview",
		enable_markview = "Enable Markview",
		disable_markview = "Disable Markview",
		toggle_hybrid_mode = "Toggle Hybrid Mode",
		toggle_split_view = "Toggle Split View",

		format_buffer = "Format buffer",
		toggle_float_terminal = "Toggle Float Terminal",
		horizontal_terminal = "Horizontal Terminal",
		vertical_terminal = "Vertical Terminal",
		gitui_float = "GitUI (float)",
		run_current_file = "Run Current File",
		terminal_number = "Terminal #$1",

		switch_buffer = "Switch Buffer (VSCode Style Ctrl+Tab)",
		quick_open = "Quick Open (VSCode Style)",
		find_buffers = "Find Buffers",
		frecency_current_dir = "Frecency (current directory)",

		terminal_toggle_root = "Terminal: Toggle (Root Dir)",
		terminal_new_root = "Terminal: New (Root Dir)",
		terminal_split_duplicate = "Terminal: Split (duplicate current)",
		terminal_kill_current = "Terminal: Kill current",
		terminal_next = "Terminal: Next",
		terminal_prev = "Terminal: Prev",

		accept_inline_suggestion = "Accept Inline Suggestion",
		inline_generation_kilo = "Inline Generation (Kilo)",
		explain_code_roo = "Explain Code (Roo)",
		chat_panel = "Chat Panel",
		show_all_commands = "Show All Commands",
		settings = "Settings",
		close_window = "Close Window",
		close_editor = "Close Editor",
		recent_files = "Recent Files",
		split_editor = "Split Editor",
		outline = "Outline",
		view_markdown = "View Markdown",
		source_control = "Source Control",
		problems = "Problems",
		close_others = "Close Others",
		external_terminal = "External Terminal",
		extensions = "Extensions",
		format_document = "Format Document",
		find_file = "Find File",
		new_search_editor = "New Search Editor",
		search_text = "Search Text",
		document_symbol = "Document Symbol",
		project_symbol = "Project Symbol",
		git_status = "Git Status",
		git_commit = "Git Commit",
		git_commit_signed = "Git Commit Signed",
		git_push = "Git Push",
		git_pull = "Git Pull",
		git_fetch = "Git Fetch",
		git_checkout = "Git Checkout",
		git_stage_all = "Git Stage All",
		open_in_system_explorer = "Open in System Explorer",
		open_in_wsl_explorer = "Open in WSL Explorer",
		fold_all = "Fold All",
		unfold_all = "Unfold All",
		toggle_code_fold = "Toggle Code Fold",
		rename_symbol = "Rename Symbol",
		quick_fix = "Quick Fix",
		go_to_references = "Go to References",
		next_marker = "Next Marker",
		prev_marker = "Previous Marker",
		toggle_line_comment = "Toggle Line Comment",
		copy_file_path = "Copy File Path",
		copy_folder_path = "Copy Folder Path",

		flash = "Flash",
		flash_treesitter = "Flash Treesitter",
		remote_flash = "Remote Flash",
		treesitter_search = "Treesitter Search",
		toggle_flash_search = "Toggle Flash Search",
		hop_word = "Hop Word",
		hop_line = "Hop Line",
		hop_char1 = "Hop Char1",
		hop_char2 = "Hop Char2",

		format_on_save = "Format on Save",
	},
	zh = {
		save_file = "保存文件",
		windows = "窗口管理",
		git = "Git",
		debug = "调试",
		session = "会话",
		buffer = "缓冲区",
		search = "搜索",
		window = "窗口",
		package = "包",
		lsp = "Lsp",
		fuzzy_find = "模糊查找",
		nvim_tree = "文件树",
		toggle_language = "切换 Which-Key 语言",

		escape_and_clear_search = "Esc 并清除搜索",
		go_to_start_of_line = "跳到行首",
		go_to_end_of_line = "跳到行尾",
		exit_insert_mode = "退出插入模式",
		add_empty_line_below = "在下方添加空行",
		add_empty_line_below_win = "在下方添加空行 (Windows Terminal)",
		focus_left_window = "将焦点移动到左侧窗口",
		focus_right_window = "将焦点移动到右侧窗口",
		focus_down_window = "将焦点移动到下方窗口",
		focus_up_window = "将焦点移动到上方窗口",
		exit_terminal_mode = "退出终端模式",
		open_diagnostic_quickfix = "打开诊断 [Q]uickfix 列表",
		copy_relative_path_absolute = "复制相对路径 (绝对路径)",
		copy_directory_path = "复制目录路径",

		next_diagnostic = "下一个诊断",
		prev_diagnostic = "上一个诊断",
		toggle_markview = "切换 Markview",
		enable_markview = "启用 Markview",
		disable_markview = "禁用 Markview",
		toggle_hybrid_mode = "切换混合模式",
		toggle_split_view = "切换分屏视图",

		format_buffer = "格式化缓冲区",
		toggle_float_terminal = "切换浮动终端",
		horizontal_terminal = "水平终端",
		vertical_terminal = "垂直终端",
		gitui_float = "GitUI (浮动)",
		run_current_file = "运行当前文件",
		terminal_number = "终端 #$1",

		switch_buffer = "切换缓冲区 (VSCode 风格 Ctrl+Tab)",
		quick_open = "快速打开 (VSCode 风格)",
		find_buffers = "查找缓冲区",
		frecency_current_dir = "Frecency (当前目录)",

		terminal_toggle_root = "终端: 切换 (根目录)",
		terminal_new_root = "终端: 新建 (根目录)",
		terminal_split_duplicate = "终端: 分屏 (复制当前)",
		terminal_kill_current = "终端: 关闭当前",
		terminal_next = "终端: 下一个",
		terminal_prev = "终端: 上一个",

		accept_inline_suggestion = "接受内联建议",
		inline_generation_kilo = "内联生成 (Kilo)",
		explain_code_roo = "解释代码 (Roo)",
		chat_panel = "聊天面板",
		show_all_commands = "显示所有命令",
		settings = "设置",
		close_window = "关闭窗口",
		close_editor = "关闭编辑器",
		recent_files = "最近文件",
		split_editor = "拆分编辑器",
		outline = "大纲",
		view_markdown = "查看 Markdown",
		source_control = "源代码管理",
		problems = "问题",
		close_others = "关闭其他",
		external_terminal = "外部终端",
		extensions = "扩展",
		format_document = "格式化文档",
		find_file = "查找文件",
		new_search_editor = "新建搜索编辑器",
		search_text = "搜索文本",
		document_symbol = "文档符号",
		project_symbol = "项目符号",
		git_status = "Git 状态",
		git_commit = "Git 提交",
		git_commit_signed = "Git 签名提交",
		git_push = "Git 推送",
		git_pull = "Git 拉取",
		git_fetch = "Git 获取",
		git_checkout = "Git 检出",
		git_stage_all = "Git 暂存所有",
		open_in_system_explorer = "在系统资源管理器中打开",
		open_in_wsl_explorer = "在 WSL 资源管理器中打开",
		fold_all = "折叠所有",
		unfold_all = "展开所有",
		toggle_code_fold = "切换代码折叠",
		rename_symbol = "重命名符号",
		quick_fix = "快速修复",
		go_to_references = "转到引用",
		next_marker = "下一个标记",
		prev_marker = "上一个标记",
		toggle_line_comment = "切换行注释",
		copy_file_path = "复制文件路径",
		copy_folder_path = "复制文件夹路径",

		flash = "Flash",
		flash_treesitter = "Flash Treesitter",
		remote_flash = "远程 Flash",
		treesitter_search = "Treesitter 搜索",
		toggle_flash_search = "切换 Flash 搜索",
		hop_word = "跳转单词",
		hop_line = "跳转行",
		hop_char1 = "跳转字符1",
		hop_char2 = "跳转字符2",

		format_on_save = "保存时格式化",
	},
}

function M.set_lang(lang)
	if vim.tbl_contains(M.available_languages, lang) then
		M.lang = lang
		pcall(vim.api.nvim_command, "WhichKeyRefresh")
	end
end

function M.toggle_lang()
	local next_lang = M.lang == "en" and "zh" or "en"
	M.set_lang(next_lang)
end

function M.t(key, ...)
	local key_args = { ... }
	local translate = M.translations[M.lang][key]

	if not translate then
		translate = M.translations["en"][key] or key
	end

	for i, arg in ipairs(key_args) do
		translate = translate:gsub("$" .. i, tostring(arg))
	end

	return translate
end

function M.setup()
	local env_lang = vim.env.WK_LANG or vim.env.NVIM_LANG
	if env_lang and vim.tbl_contains(M.available_languages, env_lang) then
		M.lang = env_lang
	end
end

M.setup()

return M
