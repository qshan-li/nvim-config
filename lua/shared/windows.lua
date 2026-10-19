local M = {}

local global = require("pure-nvim.core.global")
local i18n = require("shared.i18n")

local image_extensions = {
	avif = true,
	bmp = true,
	gif = true,
	heic = true,
	ico = true,
	jpeg = true,
	jpg = true,
	png = true,
	svg = true,
	tif = true,
	tiff = true,
	webp = true,
}

local function current_path()
	if vim.bo.filetype == "NvimTree" then
		local node = require("nvim-tree.api").tree.get_node_under_cursor()
		return node and node.absolute_path or nil
	end

	local path = vim.api.nvim_buf_get_name(0)
	return path ~= "" and vim.fn.fnamemodify(path, ":p") or nil
end

local function windows_path(path)
	if not (global.is_wsl or global.is_windows) then
		vim.notify(i18n.t("open_image_windows_only"), vim.log.levels.WARN)
		return nil
	end
	if vim.fn.executable("explorer.exe") ~= 1 then
		vim.notify(i18n.t("open_image_cmd_missing"), vim.log.levels.ERROR)
		return nil
	end
	if global.is_windows then
		return path
	end
	if vim.fn.executable("wslpath") ~= 1 then
		vim.notify(i18n.t("open_image_wslpath_missing"), vim.log.levels.ERROR)
		return nil
	end

	local converted = vim.fn.system({ "wslpath", "-w", path }):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 or converted == "" then
		vim.notify(i18n.t("open_image_path_conversion_failed"), vim.log.levels.ERROR)
		return nil
	end
	return converted
end

function M.open_in_system_explorer()
	local path = current_path()
	if not path then
		return vim.notify(i18n.t("open_path_missing"), vim.log.levels.WARN)
	end
	local converted = windows_path(path)
	if not converted then
		return
	end

	local args = vim.fn.isdirectory(path) == 1 and { "explorer.exe", converted }
		or { "explorer.exe", "/select," .. converted }
	if vim.fn.jobstart(args, { detach = true }) <= 0 then
		vim.notify(i18n.t("open_explorer_failed"), vim.log.levels.ERROR)
	end
end

function M.open_in_wsl_explorer()
	local path = current_path()
	if not path then
		return vim.notify(i18n.t("open_path_missing"), vim.log.levels.WARN)
	end
	local converted = windows_path(path)
	if not converted then
		return
	end

	local target = converted
	if vim.fn.isdirectory(path) ~= 1 then
		local directory = vim.fs.dirname(path)
		target = windows_path(directory)
		if not target then
			return
		end
	end
	if vim.fn.jobstart({ "explorer.exe", target }, { detach = true }) <= 0 then
		vim.notify(i18n.t("open_explorer_failed"), vim.log.levels.ERROR)
	end
end

function M.open_image_in_windows()
	local path = current_path()
	local extension = path and path:match("%.([^./\\]+)$")
	if not extension or not image_extensions[extension:lower()] then
		return vim.notify(i18n.t("open_image_requires_image"), vim.log.levels.WARN)
	end
	local converted = windows_path(path)
	if not converted then
		return
	end

	if vim.fn.jobstart({ "cmd.exe", "/c", "start", "", converted }, { detach = true }) <= 0 then
		vim.notify(i18n.t("open_image_failed"), vim.log.levels.ERROR)
	end
end

return M
