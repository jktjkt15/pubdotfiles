local conf = {
	providers = {
		openai = {
			endpoint = "https://api.openai.com/v1/chat/completions",
			secret = { "cat", vim.fn.stdpath("data") .. "/gpt.env" },
		},
	},
	agents = {
		{
			provider = "openai",
			name = "CodeGPT4o (mini)",
			disable = false,
			chat = false,
			command = true,
			model = { model = "gpt-4o-mini", temperature = 0.3, top_p = 0.1 },
			system_prompt = "You are a general AI assistant for a computer programmer.",
		},
		{
			provider = "openai",
			name = "CodeGPT4o",
			chat = true,
			command = true,
			model = { model = "gpt-4o", temperature = 0.3, top_p = 0.3 },
			system_prompt = "You are a general AI assistant for a computer programmer. If you don't know something, please say it and don't make things up.",
		},
	},
	default_command_agent = "CodeGPT4o",
	default_chat_agent = "CodeGPT4o",
}

require("gp").setup(conf)

vim.keymap.set({ "x" }, "<leader>ga", "<cmd>'<,'>GpNew add accents and fix typos<CR>", { desc = "GPT Eval selection" })
vim.keymap.set({ "n" }, "<leader>gn", ":GpNew ", { desc = "GPT New in command" })
vim.keymap.set({ "x" }, "<leader>gn", ":<C-u>'<,'>GpNew<cr>", { desc = "GPT New in command" })
vim.keymap.set({ "n" }, "<leader>gc", "<cmd>GpChatNew<CR>", { desc = "GPT New Chat" })
vim.keymap.set({ "v" }, "<leader>gc", ":<C-u>'<,'>GpChatNew<cr>", { desc = "GPT Chat New from selection" })
vim.keymap.set({ "n" }, "<leader>gt", "<cmd>GpChatToggle<cr>", { desc = "GPT Chat toggle" })
