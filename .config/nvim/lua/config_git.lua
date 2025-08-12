-- local gitBufNr = nil
--
-- vim.keymap.set("n", "<leader>gg", function()
-- 	if vim.api.nvim_get_current_buf() == gitBufNr then
-- 		vim.api.nvim_buf_delete(gitBufNr, {})
-- 	else
-- 		vim.cmd("Git")
-- 		gitBufNr = vim.api.nvim_get_current_buf()
-- 	end
-- end)
--
-- vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>")
-- vim.keymap.set("n", "<leader>gf", "<cmd>Git fetch<CR>")
-- vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<CR>")
-- vim.keymap.set("n", "<leader>gl", "<cmd>Git log -n 5<CR>")
-- vim.api.nvim_create_user_command("Gs", "G status", {})
-- vim.api.nvim_create_user_command("Gf", "G fetch", {})
-- vim.api.nvim_create_user_command("Gp", "G pull", {})
-- vim.api.nvim_create_user_command("Gl", "G log -n 5", {})

vim.keymap.set("n", "<leader>gh", function()
	local ok, gitSshUri = pcall(vim.fn.system, { "git", "remote", "get-url", "--push", "origin" }, nil)

	if not ok then
		return
	end

	local url = gitSshUri:gsub("\n", ""):gsub("git@github.com:", "https://github.com/"):gsub("%.git$", "")

	vim.fn.system({ "brave", url })
end)

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- 	pattern = { "fugitive", "fugitiveblame" },
-- 	group = vim.api.nvim_create_augroup("fugitive_group", { clear = true }),
-- 	callback = function()
-- 		print("abc")
-- 		vim.api.nvim_buf_set_keymap(0, "n", "(", "=", { silent = true, noremap = false })
-- 	end,
-- })
