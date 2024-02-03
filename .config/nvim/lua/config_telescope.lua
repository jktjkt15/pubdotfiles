local telescope = require("telescope")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

local baseThemeOptions = {
	layout_config = { width = 0.9, height = 0.8 },
	layout_strategy = "horizontal",
	file_ignore_patterns = { "obj/*", "dll/*", ".git/*", ".nuget/*" },
}

vim.keymap.set("n", "<leader>fcc", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { cwd = utils.buffer_dir(), hidden = true })
	builtin.find_files(opts)
end)
vim.keymap.set("n", "<leader>ff", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { hidden = true })
	builtin.find_files(opts)
end)
vim.keymap.set("n", "<leader>fgg", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.live_grep(opts)
end)
vim.keymap.set("n", "<leader>fgc", function()
	local opts =
		vim.tbl_deep_extend("force", baseThemeOptions, { cwd = utils.buffer_dir(), layout_strategy = "vertical" })
	builtin.live_grep(opts)
end)
vim.keymap.set("n", "<leader>fb", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, {})
	builtin.buffers(opts)
end)
vim.keymap.set("n", "<leader>fh", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.help_tags(opts)
end)
vim.keymap.set("n", "<leader>fch", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, {})
	builtin.command_history(opts)
end)
vim.keymap.set("n", "<leader>fe", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.diagnostics(opts)
end)
vim.keymap.set("n", "<leader>fr", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.lsp_references(opts)
end)
vim.keymap.set("n", "<leader>fd", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.lsp_document_symbols(opts)
end)

vim.keymap.set("n", "<leader>fs", function()
	local opts = vim.tbl_deep_extend("force", baseThemeOptions, { layout_strategy = "vertical" })
	builtin.lsp_workspace_symbols(opts)
end)
vim.keymap.set("n", "<leader>fu", function()
	telescope.extensions.undo.undo()
end)
vim.keymap.set("n", "<leader>fp", function()
	require("workspaces")
	vim.schedule(telescope.extensions.workspaces.workspaces)
end)

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
