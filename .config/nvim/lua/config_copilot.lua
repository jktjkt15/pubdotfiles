require("copilot").setup({
	panel = {
		enabled = false,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "right", -- | top | left | right
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = false,
		auto_trigger = false,
		debounce = 75,
		keymap = {
			accept = "<C-n>",
			accept_word = false,
			accept_line = false,
			next = "<C-a>",
			prev = "<C-b>",
			dismiss = "<C-q>",
		},
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = "node",
	server_opts_overrides = {},
})

local toggleCopilot = false

vim.keymap.set("n", "<leader>co", function()
	if toggleCopilot then
		vim.cmd({ cmd = "Copilot", args = { "disable" } })
		toggleCopilot = false
	else
		vim.cmd({ cmd = "Copilot", args = { "auth" } })
		vim.cmd({ cmd = "Copilot", args = { "enable" } })
		vim.cmd({ cmd = "Copilot", args = { "suggestion" } })
		toggleCopilot = true
	end
end)
