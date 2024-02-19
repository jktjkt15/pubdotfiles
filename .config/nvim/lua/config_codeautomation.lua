local function FindBaseProjectFolder()
	local currentFolder = vim.fn.expand("%:h")
	local targetFolder = vim.fs.root(currentFolder, function(name)
		return name:match("%.csproj$") ~= nil
	end)

	return vim.fs.basename(targetFolder)
end

local function GetCurrentFileName()
	return vim.fn.expand("%:t:r")
end

vim.keymap.set("n", "<leader>cg", function()
	return "mm<cmd>r! pwsh ~/repos/codeautomation/newclass.ps1 "
		.. FindBaseProjectFolder()
		.. " "
		.. GetCurrentFileName()
		.. "<CR>'mdd"
end, { expr = true, silent = true, desc = "Code Generation" })
