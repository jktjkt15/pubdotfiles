require("nvim-toggler").setup({
	inverses = {
		["vim"] = "emacs",
		["prev"] = "next",
		["high"] = "low",
		["fail"] = "pass",
		["public"] = "internal",
	},
	remove_default_keybinds = true,
	remove_default_inverses = false,
})

vim.keymap.set({ "n", "v" }, "<leader>ct", require("nvim-toggler").toggle)
