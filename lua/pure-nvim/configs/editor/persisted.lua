return function()
	-- Neovide 由 Windows 启动，cwd 固定为 neovide.exe 所在目录，与项目无关。
	-- 按 cwd 自动加载会命中该目录的 session，因此改为恢复最近一次使用的 session。
	local restore_last = vim.g.neovide == true

	require("pure-nvim.utils").load_plugin("persisted", {
		save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
		autostart = true,
		autoload = not restore_last,
		follow_cwd = true,
		use_git_branch = true,
		should_save = function()
			return vim.bo.filetype == "minintro" and false or true
		end,
	})

	if not restore_last then
		return
	end

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			-- 带文件参数时不覆盖，例如从资源管理器「用 Neovide 打开」
			if vim.fn.argc() > 0 then
				return
			end
			require("persisted").load({ last = true })
		end,
	})
end
