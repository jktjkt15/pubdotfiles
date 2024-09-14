local telescope = require("telescope")

vim.keymap.set("n", "<leader>fu", function()
	telescope.extensions.undo.undo()
end)

-- vim.keymap.set("n", "<leader>fp", function()
-- 	require("workspaces")
-- 	vim.schedule(telescope.extensions.workspaces.workspaces)
-- end)

require("telescope").setup({
	extensions = {
		workspaces = {
			enabled = false,
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			file_ignore_patterns = {
				"initjc.lua",
			},
		},
		undo = {
			enabled = true,
			delta = true,
			side_by_side = true,
			layout_strategy = "horizontal",
			layout_config = {
				preview_width = 0.7,
			},
		},
	},
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			width = 0.9,
		},
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
				["<C-h>"] = require("telescope.actions").select_horizontal,
				["<C-v>"] = require("telescope.actions").select_vertical,
			},
		},
	},
})

-- require("telescope").load_extension("fzf")
