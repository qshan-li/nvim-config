return function()
	local api = require("nvim-tree.api")

	local function on_attach(bufnr)
		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		-- 默认映射
		api.config.mappings.default_on_attach(bufnr)

		-- 自定义映射
		vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
		vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		vim.keymap.set("n", "gy", function()
			local node = api.tree.get_node_under_cursor()
			if not node then
				return vim.notify("No node under cursor", vim.log.levels.WARN)
			end
			local ok, error_message = require("shared.clipboard").copy(node.absolute_path)
			if not ok then
				return vim.notify("Failed to copy: " .. tostring(error_message), vim.log.levels.ERROR)
			end
		end, opts("Yank Path"))

		-- Vim 风格导航（类似 mini.files）
		-- l: 展开目录或打开文件
		-- h: 收起目录或返回上级
		vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
		vim.keymap.set("n", "L", api.tree.expand_all, opts("Expand All"))
		vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
	end

	local icons = {
		ui = require("pure-nvim.utils.icons").get("ui"),
		git = require("pure-nvim.utils.icons").get("git"),
		documents = require("pure-nvim.utils.icons").get("documents"),
	}

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match("NvimTree") then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end

	require("nvim-tree").setup({
		on_attach = on_attach,
		sort_by = "case_sensitive",
		log = {
			enable = false,
		},
		notify = {
			threshold = vim.log.levels.WARNING,
		},
		view = {
			width = 40,
			side = "right",
		},
		-- 与当前 buffer 联动
		update_focused_file = {
			enable = false, -- 切换 buffer 时，自动在 tree 中选中对应文件
			update_root = true, -- 如果文件不在当前根目录下，自动更新根目录
		},
		sync_root_with_cwd = true, -- 当 nvim 的 CWD 改变时，同步更新 tree 的根目录
		renderer = {
			add_trailing = false,
			group_empty = false,
			highlight_git = true,
			full_name = false,
			highlight_opened_files = "none",
			root_folder_label = ":~:s?$?/..?",
			indent_width = 2,
			indent_markers = {
				enable = true,
				inline_arrows = true,
				icons = {
					corner = "└",
					edge = "│",
					item = "│",
					bottom = "─",
					none = " ",
				},
			},
			icons = {
				webdev_colors = true,
				git_placement = "before",
				padding = " ",
				symlink_arrow = " ➜ ",
				show = {
					file = true,
					folder = true,
					folder_arrow = false,
					git = false,
				},
				glyphs = {
					default = icons.documents.File,
					symlink = icons.documents.Symlink,
					bookmark = icons.ui.BookMark,
					git = {
						unstaged = icons.git.Unstaged,
						staged = icons.git.Staged,
						unmerged = icons.git.Unmerged,
						renamed = icons.git.Rename,
						untracked = icons.git.Untracked,
						deleted = icons.git.Remove,
						ignored = icons.git.Ignore,
					},
					folder = {
						arrow_open = icons.ui.ArrowOpen,
						arrow_closed = icons.ui.ArrowClosed,
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.SymlinkFolder,
						symlink_open = icons.ui.SymlinkFolder,
					},
				},
			},
		},
		filters = {
			dotfiles = false,
			custom = { "^\\.git$", "^\\.cache$" }, -- 过滤这些文件/文件夹
		},
		git = {
			enable = true,
			ignore = false,
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = false, -- 如果为 true，即使过滤也显示文件夹
		},
		actions = {
			open_file = {
				quit_on_open = false,
				resize_window = true,
			},
		},
	})
end
