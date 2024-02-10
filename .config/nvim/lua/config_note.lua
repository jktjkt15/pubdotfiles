vim.keymap.set("n", "<leader>nn", function()
	local path = vim.fs.joinpath(vim.fn.stdpath("data"), "global.md")
	return vim.cmd("e " .. path)
end, {
	desc = "Toggle global note",
})
