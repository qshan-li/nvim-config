local bind = require("pure-nvim.keymap.bind")
local map_cr = bind.map_cr
local map_callback = bind.map_callback

local function trim_empty_markdown_lines(markdown_lines)
	return vim.split(table.concat(markdown_lines, "\n"), "\n", { plain = true, trimempty = true })
end

local function silent_hover()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return
	end

	local offset_encoding = "utf-16"
	for _, client in ipairs(clients) do
		if client.supports_method and client:supports_method("textDocument/hover") then
			offset_encoding = client.offset_encoding or offset_encoding
			break
		end
	end

	local params = vim.lsp.util.make_position_params(0, offset_encoding)

	vim.lsp.buf_request_all(bufnr, "textDocument/hover", params, function(results)
		for _, res in pairs(results) do
			local result = res.result
			if result and result.contents then
				local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
				markdown_lines = trim_empty_markdown_lines(markdown_lines)

				if #markdown_lines > 0 then
					vim.lsp.util.open_floating_preview(markdown_lines, "markdown", { border = "single", focus = false })
					return
				end
			end
		end
	end)
end

local mappings = {
	fmt = {
		-- ["n|<leader>f"] = map_cr("Format"):with_noremap():with_silent():with_desc("formatter: Format buffer manually"),  -- 已禁用，避免与 <leader>ff> 冲突
		["n|<A-f>"] = map_cr("FormatToggle"):with_noremap():with_silent():with_desc("formatter: Toggle format on save"),
		["n|<A-S-f>"] = map_cr("Format"):with_noremap():with_silent():with_desc("formatter: Format buffer manually"),
	},
	neocodeium = {
		["i|<A-f>"] = map_callback(function()
				require("neocodeium").accept()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Accept suggestion"),
		["i|<A-w>"] = map_callback(function()
				require("neocodeium").accept_word()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Accept word"),
		["i|<A-a>"] = map_callback(function()
				require("neocodeium").accept_line()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Accept line"),
		["i|<A-e>"] = map_callback(function()
				require("neocodeium").cycle_or_complete()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Cycle or complete"),
		["i|<A-r>"] = map_callback(function()
				require("neocodeium").cycle_or_complete(-1)
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Cycle reverse"),
		["i|<A-c>"] = map_callback(function()
				require("neocodeium").clear()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("neocodeium: Clear suggestion"),
	},
}
bind.nvim_load_mapping(mappings.fmt)
bind.nvim_load_mapping(mappings.neocodeium)

--- The following code allows this file to be exported ---
---    for use with LSP lazy-loaded keymap bindings    ---

local M = {}

---@param buf integer
function M.lsp(buf)
	local map = {
		-- LSP-related keymaps, ONLY effective in buffers with LSP(s) attached
		["n|<leader>li"] = map_cr("LspInfo"):with_silent():with_buffer(buf):with_desc("lsp: Info"),
		["n|<leader>lr"] = map_cr("LspRestart"):with_silent():with_buffer(buf):with_nowait():with_desc("lsp: Restart"),
		["n|gto"] = map_callback(function()
				require("fzf-lua").lsp_live_workspace_symbols()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Toggle outline in Picker"),
		["n|<leader>dk"] = map_callback(function()
				vim.diagnostic.goto_prev()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Prev diagnostic"),
		["n|<leader>dj"] = map_callback(function()
				vim.diagnostic.goto_next()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Next diagnostic"),
		["n|gs"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end):with_desc("lsp: Signature help"),
		["n|gr"] = map_cr("IncRename")
			:with_silent()
			:with_nowait()
			:with_buffer(buf)
			:with_desc("lsp: Rename in file range"),
		["n|gR"] = map_cr("IncRename"):with_silent():with_buffer(buf):with_desc("lsp: Rename in project range"),
		["n|K"] = map_callback(silent_hover):with_silent():with_buffer(buf):with_desc("lsp: Show doc"),
		["nv|<A-f12>/"] = map_callback(function()
				require("tiny-code-action").code_action()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Code action for cursor"),
		["n|gd"] = map_callback(function()
				vim.lsp.buf.definition()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Goto definition"),
		["n|gD"] = map_cr("Glance definitions"):with_silent():with_buffer(buf):with_desc("lsp: Preview definition"),
		["n|gh"] = map_callback(function()
				local pos = vim.api.nvim_win_get_cursor(0)
				local diags = vim.diagnostic.get(0, { lnum = pos[1] - 1, col = pos[2] })
				if #diags > 0 then
					vim.diagnostic.open_float(nil, { focus = false })
				else
					silent_hover()
				end
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Hover or Diagnostics"),
		["n|<leader>u"] = map_callback(function()
				vim.lsp.buf.references(nil, {
					on_list = function(list)
						vim.fn.setqflist({}, " ", list)
						vim.cmd("botright copen")
						local qf_buf = vim.api.nvim_get_current_buf()
						vim.keymap.set("n", "<CR>", function()
							local line = vim.fn.line(".")
							vim.cmd("cc " .. line)
							pcall(vim.cmd, "lclose")
							pcall(vim.cmd, "cclose")
						end, { buffer = qf_buf, silent = true })
						vim.keymap.set("n", "<Esc>", "<Cmd>cclose<CR>", { buffer = qf_buf, silent = true })
						vim.keymap.set("n", "<C-c>", "<Cmd>cclose<CR>", { buffer = qf_buf, silent = true })
					end,
				})
			end)
			:with_buffer(buf)
			:with_desc("lsp: Go to references"),
		["n|<leader>rn"] = map_cr("IncRename"):with_buffer(buf):with_desc("lsp: Rename symbol"),
		["n|gm"] = map_cr("Glance implementations")
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Show implementation"),
		["n|gci"] = map_callback(function()
				vim.lsp.buf.incoming_calls()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Show incoming calls"),
		["n|gco"] = map_callback(function()
				vim.lsp.buf.outgoing_calls()
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("lsp: Show outgoing calls"),
		["n|<leader>lv"] = map_callback(function()
				require("tiny-inline-diagnostic").toggle()
				local enabled = require("tiny-inline-diagnostic.diagnostic").user_toggle_state
				vim.notify(
					"Inline diagnostics " .. (enabled and "enabled" or "disabled") .. " successfully",
					vim.log.levels.INFO,
					{ title = "LSP Diagnostic" }
				)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Toggle diagnostic virtual text"),
		["n|<leader>lh"] = map_callback(function()
				local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
				vim.lsp.inlay_hint.enable(not is_enabled)
				vim.notify(
					(is_enabled and "Inlay hint disabled successfully" or "Inlay hint enabled successfully"),
					vim.log.levels.INFO,
					{ title = "LSP Inlay Hint" }
				)
			end)
			:with_noremap()
			:with_silent()
			:with_desc("lsp: Toggle inlay hints"),
	}
	bind.nvim_load_mapping(map)
end

return M
