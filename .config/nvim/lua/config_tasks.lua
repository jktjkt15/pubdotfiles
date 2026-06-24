local tasks = {
	-- ["stop roslyn"] = function()
	-- 	vim.cmd("lsp stop roslyn")
	-- end,
	-- ["start roslyn"] = function()
	-- 	vim.cmd("lsp start roslyn")
	-- end,
	["copilot chat"] = function()
		vim.cmd("CopilotChat")
	end,
}

local function getTasksOptions()
	return {
		prompt = "Tasks > ",
		-- fzf_opts = {
		-- 	-- ["--delimiter"] = delimiter,
		-- 	-- ["--nth"] = "1",
		-- 	-- ["--with-nth"] = "1",
		-- },
		actions = {
			["enter"] = function(selected)
				local taskId = selected[1]
				local task = tasks[taskId]
				task()
			end,
		},
		exec_empty_query = true,
	}
end

local function getTasks()
	return coroutine.wrap(function(fzf_cb)
		local choices = tasks

		for key, _ in pairs(choices) do
			fzf_cb(key)
		end

		fzf_cb()
	end)
end

vim.keymap.set("n", "<leader>tt", function()
	require("fzf-lua").fzf_live(getTasks, getTasksOptions())
end, { desc = "tasks" })

vim.keymap.set("n", "<leader>cp", function()
	vim.cmd("CopilotChatToggle")
end, { desc = "Copilot chat" })
