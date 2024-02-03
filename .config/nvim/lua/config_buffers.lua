local opts = { noremap = true }
local map = vim.keymap.set

local harpoon = require("harpoon")

harpoon:setup({
	menu = {
		width = 100,
	},
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = false,
		key = function()
			return vim.loop.cwd()
		end,
	},
})

map({ "t", "n" }, "<leader>a", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, opts)

map({ "n" }, "<leader>xa", function()
	harpoon:list():append()
end, opts)

map({ "n" }, "<leader>xx", function()
	harpoon:list():prev()
end, opts)

for i = 1, 9 do
	map({ "n" }, "<leader>" .. i, function()
		harpoon:list():select(i)
	end, opts)
end
