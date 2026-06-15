local M = {}

---@class palette
---@field rosewater string
---@field flamingo string
---@field mauve string
---@field pink string
---@field red string
---@field maroon string
---@field peach string
---@field yellow string
---@field green string
---@field sapphire string
---@field blue string
---@field sky string
---@field teal string
---@field lavender string
---@field text string
---@field subtext1 string
---@field subtext0 string
---@field overlay2 string
---@field overlay1 string
---@field overlay0 string
---@field surface2 string
---@field surface1 string
---@field surface0 string
---@field base string
---@field mantle string
---@field crust string
---@field none "NONE"

---@type nil|palette
local palette = nil

-- Indicates if autocmd for refreshing the builtin palette has already been registered
---@type boolean
local _has_autocmd = false

---Initialize the palette
---@return palette
local function init_palette()
	-- Reinitialize the palette on event `ColorScheme`
	if not _has_autocmd then
		_has_autocmd = true
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("__builtin_palette", { clear = true }),
			pattern = "*",
			callback = function()
				palette = nil
				init_palette()
				-- Also refresh hard-coded hl groups
				M.gen_lspkind_hl()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end

	if not palette then
		local colorscheme_name = vim.g.colors_name or ""

		if colorscheme_name:find("rose%-pine") then
			local rose_pine_palette = require("rose-pine.palette")
			palette = {
				rosewater = rose_pine_palette.rose,
				flamingo = rose_pine_palette.rose,
				mauve = rose_pine_palette.iris,
				pink = rose_pine_palette.iris,
				red = rose_pine_palette.love,
				maroon = rose_pine_palette.love,
				peach = rose_pine_palette.gold,
				yellow = rose_pine_palette.gold,
				green = rose_pine_palette.leaf,
				sapphire = rose_pine_palette.foam,
				blue = rose_pine_palette.pine,
				sky = rose_pine_palette.foam,
				teal = rose_pine_palette.foam,
				lavender = rose_pine_palette.iris,

				text = rose_pine_palette.text,
				subtext1 = rose_pine_palette.subtle,
				subtext0 = rose_pine_palette.muted,
				overlay2 = rose_pine_palette.highlight_high,
				overlay1 = rose_pine_palette.highlight_med,
				overlay0 = rose_pine_palette.overlay,
				surface2 = rose_pine_palette.highlight_high,
				surface1 = rose_pine_palette.highlight_med,
				surface0 = rose_pine_palette.overlay,

				base = rose_pine_palette.base,
				mantle = rose_pine_palette.surface,
				crust = rose_pine_palette._nc or rose_pine_palette.surface,
				none = rose_pine_palette.none,
			}
		else
			palette = {
				rosewater = "#DC8A78",
				flamingo = "#DD7878",
				mauve = "#CBA6F7",
				pink = "#F5C2E7",
				red = "#E95678",
				maroon = "#B33076",
				peach = "#FF8700",
				yellow = "#F7BB3B",
				green = "#AFD700",
				sapphire = "#36D0E0",
				blue = "#61AFEF",
				sky = "#04A5E5",
				teal = "#B5E8E0",
				lavender = "#7287FD",

				text = "#F2F2BF",
				subtext1 = "#BAC2DE",
				subtext0 = "#A6ADC8",
				overlay2 = "#C3BAC6",
				overlay1 = "#988BA2",
				overlay0 = "#6E6B6B",
				surface2 = "#6E6C7E",
				surface1 = "#575268",
				surface0 = "#302D41",

				base = "#1D1536",
				mantle = "#1C1C19",
				crust = "#161320",
			}
		end

		palette =
			vim.tbl_extend("force", { none = "NONE" }, palette, require("pure-nvim.core.settings").palette_overwrite)
	end

	return palette
end

---@param c string @The color in hexadecimal.
local function hex_to_rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---Sets a global highlight group.
---@param name string @Highlight group name, e.g. "ErrorMsg"
---@param foreground? string @The foreground color
---@param background? string @The background color
---@param italic? boolean
local function set_global_hl(name, foreground, background, italic)
	vim.api.nvim_set_hl(0, name, {
		fg = foreground,
		bg = background,
		italic = italic == true,
		default = true,
	})
end

---Blend foreground with background
---@param foreground string @The foreground color
---@param background string @The background color to blend with
---@param alpha number|string @Number between 0 and 1 for blending amount.
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = hex_to_rgb(background)
	local fg = hex_to_rgb(foreground)

	local blend_channel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blend_channel(1), blend_channel(2), blend_channel(3))
end

---Darken a color by blending it with the background color.
---@param hex string @The color in hex to darken
---@param amount number @The amount to darken the color
---@param bg string @The background color to blend with
---@return string @The darkened color as a hex string
function M.darken(hex, amount, bg)
	return M.blend(hex, bg or "#000000", math.abs(amount))
end

---Generate universal highlight groups
---@param overwrite palette? @The color to be overwritten | highest priority
---@return palette
function M.get_palette(overwrite)
	if not overwrite then
		return vim.deepcopy(init_palette(), true)
	else
		return vim.tbl_extend("force", init_palette(), overwrite)
	end
end

-- Generate highlight groups for LSP kinds. Existing attributes will NOT be overwritten
function M.gen_lspkind_hl()
	local colors = M.get_palette()
	local dat = {
		Class = colors.yellow,
		Constant = colors.peach,
		Constructor = colors.sapphire,
		Enum = colors.yellow,
		EnumMember = colors.teal,
		Event = colors.yellow,
		Field = colors.teal,
		File = colors.rosewater,
		Function = colors.blue,
		Interface = colors.yellow,
		Key = colors.red,
		Method = colors.blue,
		Module = colors.blue,
		Namespace = colors.blue,
		Number = colors.peach,
		Operator = colors.sky,
		Package = colors.blue,
		Property = colors.teal,
		Struct = colors.yellow,
		TypeParameter = colors.blue,
		Variable = colors.peach,
		Array = colors.peach,
		Boolean = colors.peach,
		Null = colors.yellow,
		Object = colors.yellow,
		String = colors.green,
		TypeAlias = colors.green,
		Parameter = colors.blue,
		StaticMethod = colors.peach,
		Text = colors.green,
		Snippet = colors.mauve,
		Folder = colors.blue,
		Unit = colors.green,
		Value = colors.peach,
	}

	for kind, color in pairs(dat) do
		set_global_hl("LspKind" .. kind, color)
	end
end

-- Generate highlight groups for cursorword. Existing attributes will NOT be overwritten
function M.gen_cursorword_hl()
	local colors = M.get_palette()

	-- Do not highlight `MiniCursorwordCurrent`
	set_global_hl("MiniCursorword", nil, M.darken(colors.surface1, 0.7, colors.base))
	set_global_hl("MiniCursorwordCurrent", nil)
end

---Build the default LSP client capabilities used across the config.
function M.get_lsp_capabilities()
	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	local completion_item = vim.tbl_get(capabilities, "textDocument", "completion", "completionItem")
	if completion_item then
		completion_item.snippetSupport = false
	end

	return capabilities
end

---Setup and enable a language server in one call.
---@param server string @Name of the language server
---@param config? vim.lsp.Config @Optional config to apply
function M.register_server(server, config)
	vim.validate({
		server = { server, "string" },
		config = { config, "table", true },
	})

	if config then
		vim.lsp.config(server, config)
	end
	vim.lsp.enable(server)
end

---@param plugin_name string @Module name of the plugin (used to setup itself)
---@param opts nil|table @The default config to be merged with
---@param vim_plugin? boolean @If this plugin is written in vimscript or not
---@param setup_callback? function @Add new callback if the plugin needs unusual setup function
function M.load_plugin(plugin_name, opts, vim_plugin, setup_callback)
	vim_plugin = vim_plugin or false

	if vim_plugin then
		if setup_callback then
			setup_callback()
		end
		return
	end

	setup_callback = setup_callback or require(plugin_name).setup
	setup_callback(opts)
end

return M
