---@diagnostic disable: param-type-mismatch, redundant-parameter

vim.cmd([[set clipboard=unnamedplus]])

-- ssh remote
if os.getenv("SSH_TTY") ~= nil then
	local folderPath = vim.fn.stdpath("data") .. "/clip"
	pcall(vim.fn.mkdir, folderPath, nil)

	local filePath = folderPath .. "/clipboard.txt"

	local function copy(lines)
		vim.fn.writefile(lines, filePath)
	end

	local function paste()
		return vim.fn.readfile(filePath)
	end

	-- local function copy(lines)
	-- 	vim.g.JayReg = lines
	-- end
	--
	-- local function paste()
	-- 	return vim.g.JayReg
	-- end

	vim.g.clipboard = {
		name = "jayLocal",
		copy = {
			["+"] = copy,
			["*"] = copy,
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}

	vim.keymap.set({ "n", "x" }, "<localleader>y", _G.__JaySSHYank, { expr = true, desc = "SSH Yank" })

	-- vim.keymap.set({ "n" }, "<leader>P", function()
	-- 	local a = require("vim.ui.clipboard.osc52").paste("*")()
	-- 	vim.notify(vim.inspect(a))
	-- 	return a
	-- end, { desc = "SSH Paste" })
end
