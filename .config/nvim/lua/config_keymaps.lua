-- Save
vim.keymap.set("n", "<leader>w", ":silent w<CR>")

-- Centered Scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Explorer .
vim.keymap.set("n", "<leader>ex", function()
	os.execute('explorer "' .. vim.fn.expand("%:p:h") .. '"')
end, { silent = true })

-- Go-back 1
vim.keymap.set("n", "-", "<C-6>")
vim.keymap.set("n", "<C-p>", "<C-6>")

-- Remapping redo
vim.keymap.set("n", "<leader>u", "<C-r>")

-- Clear highlights
-- vim.keymap.set("n", "<leader>nh", "<cmd>nohl<cr>")
vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>")

-- CamelMotions
vim.keymap.set(
	{ "n" },
	"w",
	"<cmd>lua require('spider').motion('w', { skipInsignificantPunctuation = true, subwordMovement = false })<CR>",
	{ desc = "Spider-remapped-w" }
)

vim.keymap.set(
	{ "n" },
	"b",
	"<cmd>lua require('spider').motion('b', { skipInsignificantPunctuation = true, subwordMovement = false })<CR>",
	{ desc = "Spider-remapped-b" }
)

vim.keymap.set(
	{ "n" },
	"e",
	"<cmd>lua require('spider').motion('e', { skipInsignificantPunctuation = true, subwordMovement = false })<CR>",
	{ desc = "Spider-remapped-b" }
)

vim.keymap.set(
	{ "n" },
	"ge",
	"<cmd>lua require('spider').motion('ge', { skipInsignificantPunctuation = true, subwordMovement = false })<CR>",
	{ desc = "Spider-remapped-ge" }
)

vim.keymap.set({ "n", "o", "x" }, "<localleader>w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "<localleader>e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "<localleader>b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set(
	{ "n", "o", "x" },
	"<localleader>ge",
	"<cmd>lua require('spider').motion('ge')<CR>",
	{ desc = "Spider-b" }
)

-- vim.keymap.set({ "n", "t", "v" }, "gx", "<cmd>silent !Start-Process <cWORD><cr>", { silent = true })

-- Script execution in current buffer
-- vim.keymap.set('n', '<leader>r', "<cmd>w<cr>G:r ! ./%<cr>")
-- vim.keymap.set("n", "<leader>j", '<cmd>call jobstart("jira " . expand("<cWORD>"))<cr>')

-- Lazy / Mason
vim.keymap.set("n", "<leader>lz", vim.cmd.Lazy, { silent = true })
vim.keymap.set("n", "<leader>lm", vim.cmd.Mason, { silent = true })

-- Oil
vim.keymap.set("n", "<leader>o", vim.cmd.Oil)

-- Inlay hints
vim.keymap.set("n", "<leader>si", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- -- Breathing room
-- vim.keymap.set("n", "<leader>bb", "mzo<esc>`z")
-- vim.keymap.set("n", "<leader>B", "mzO<esc>`z")
-- vim.keymap.set("n", "<leader>bi", "i <esc><Right>")
-- vim.keymap.set("n", "<leader>ba", "a <esc><Left>")

-- Swapping windows
local function swapper()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>r", true, false, true), "n", false)
end

local choices = {
	"<C-w>J",
	"<C-w>L",
}

local currentChoice = 1

local function layoutToggle()
	local cmd = choices[currentChoice]

	currentChoice = (currentChoice % #choices) + 1

	if cmd then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "x", true)
	end
end

vim.keymap.set("n", "<leader>sw", layoutToggle)
vim.keymap.set("n", "<leader>ss", swapper)

-- M to cut rest of line
-- vim.keymap.set("n", "M", "D")

-- Quick access
vim.keymap.set("n", "<leader>el", ":e ~/.config/nvim/lua/init.lua<cr>")
vim.keymap.set("n", "<leader>sc", ":w<cr>:so %<cr>")

-- Exit
-- vim.keymap.set({ "n", "t" }, "<F4>", "<cmd>qa<cr>")

-- Term promt
-- vim.keymap.set("n", "<leader>d", ":sp|te ")

-- Terminal Helpers
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

vim.keymap.set("t", "<C-R>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-S>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-F>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-T>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-c>", "<C-n>")
vim.keymap.set("t", "<C-z>", "<C-c>")

-- Windows navigation
vim.keymap.set({ "n", "i" }, "<C-R>", "<C-w>h")
vim.keymap.set({ "n", "i" }, "<C-S>", "<C-w>j")
vim.keymap.set({ "n", "i" }, "<C-F>", "<C-w>k")
vim.keymap.set({ "n", "i" }, "<C-T>", "<C-w>l")

-- Terms buffer start in insert mode
vim.api.nvim_create_autocmd({ "TermEnter", "TermOpen", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("term_setting", { clear = true }),
	pattern = "term://*",
	command = "startinsert",
})

-- Next diagnostic
vim.keymap.set("n", "jd", function()
	local ok, diag = pcall(vim.diagnostic.get_next)

	if ok and diag ~= nil then
		vim.api.nvim_win_set_cursor(0, { diag.lnum + 1, diag.col })
	end
	-- print(vim.inspect(diag))
end)

vim.keymap.set("n", "jD", function()
	local ok, diag = pcall(vim.diagnostic.get_prev)

	if ok and diag ~= nil then
		vim.api.nvim_win_set_cursor(0, { diag.lnum + 1, diag.col })
	end
end)

-- LSP
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
	vim.fn.feedkeys("zz", "m")
end, { silent = true })
vim.keymap.set("n", "gh", function()
	vim.lsp.buf.hover()
end)
vim.keymap.set("n", "gi", function()
	vim.lsp.buf.implementation()
	vim.fn.feedkeys("zz", "m")
end)
vim.keymap.set("n", "<leader>rr", function()
	vim.lsp.buf.rename()
end)
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vim.lsp.buf.code_action()
end)

-- Open Url
local function OpenUrl()
	local bufnr = vim.api.nvim_get_current_buf()

	local visualPos = vim.fn.getpos("v")[3]
	local cursor = vim.fn.getcurpos()
	local cursorPos = cursor[3]
	local line = cursor[2]

	local startCol = cursorPos
	local endCol = visualPos

	if startCol > endCol then
		startCol = visualPos
		endCol = cursorPos
	end

	local text = vim.api.nvim_buf_get_text(bufnr, line - 1, startCol - 1, line - 1, endCol, {})

	vim.fn.system({ "brave" }, text)
end

vim.keymap.set("v", "gx", OpenUrl)
