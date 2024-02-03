local gs = require("gitsigns")

gs.setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
})

-- Navigation
vim.keymap.set("n", "<leader>jh", function()
	if vim.wo.diff then
		return "<leader>jh"
	end
	vim.schedule(function()
		gs.next_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

vim.keymap.set("n", "<leader>jH", function()
	if vim.wo.diff then
		return "<leader>jH"
	end
	vim.schedule(function()
		gs.prev_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

-- Actions
vim.keymap.set("n", "<leader>hs", gs.stage_hunk)
vim.keymap.set("n", "<leader>hr", gs.reset_hunk)
vim.keymap.set("v", "<leader>hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("v", "<leader>hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
vim.keymap.set("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end)
vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame)
vim.keymap.set("n", "<leader>hd", gs.diffthis)
vim.keymap.set("n", "<leader>hD", function()
	gs.diffthis("~")
end)
vim.keymap.set("n", "<leader>gd", gs.toggle_deleted)

-- Text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
