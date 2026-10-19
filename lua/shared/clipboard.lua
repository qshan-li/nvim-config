local M = {}

function M.copy(text)
	if not text or text == "" then
		error("clipboard text is empty")
	end

	vim.fn.setreg("+", text)
	return true
end

return M
