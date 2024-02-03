local function ManualLoad()
	local initFilePath = vim.fn.expand("initjc.lua")

	if vim.fn.filereadable(initFilePath) == 1 then
		vim.cmd("source " .. initFilePath)
	end
end

vim.keymap.set("n", "<leader>ll", "<cmd>e " .. vim.fn.expand("initjc.lua") .. "<CR>")

local M = {}

function M.load()
	ManualLoad()
end

return M
