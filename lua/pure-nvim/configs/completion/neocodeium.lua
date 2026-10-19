return function()
	local cmp = require("cmp")
	local neocodeium = require("neocodeium")

	cmp.event:on("menu_opened", function()
		neocodeium.clear()
	end)

	neocodeium.setup({
		enabled = true,
		show_label = true,
		debounce = false,
		max_lines = 10000,
		silent = true,
		single_line = {
			enabled = false,
		},
		filter = function()
			return not cmp.visible()
		end,
		filetypes = {
			help = false,
			gitcommit = false,
			gitrebase = false,
			["."] = false,
		},
	})
end
