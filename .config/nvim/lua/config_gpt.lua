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
			name = "CodeGPT4o-mini",
			chat = false,
			command = true,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
		},
		-- {
		-- 	provider = "openai",
		-- 	name = "Chatter",
		-- 	chat = true,
		-- 	command = false,
		-- 	-- string with model name or table with model name and parameters
		-- 	model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
		-- 	-- system prompt (use this to specify the persona/role of the AI)
		-- 	system_prompt = "You're a friend",
		-- },
	},
}

require("gp").setup(conf)

vim.keymap.set({ "x" }, "<leader>gp", "<cmd>'<,'>GpNew implement the following<CR>", { desc = "GPT Eval selection" })
