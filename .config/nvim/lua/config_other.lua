-- TODO: add check if file exists
vim.keymap.set("n", "<leader>po", function()
	local extension = vim.api.nvim_eval("expand('%:e')")

	if extension ~= "cs" then
		return
	end

	local filename = vim.api.nvim_eval("expand('%:p')")

	-- local basecwd = vim.uv.cwd()

	local mono = require("config_monorepo")

	local subRepo = mono.GetCurrentSubRepo()
	local subProject = mono.GetCurrentSubProject()

	if subRepo == "All" then
		subRepo = ""
	end
	if subProject == "All" then
		subProject = ""
	end

	local basecwd = vim.fs.joinpath(vim.uv.cwd(), subRepo, subProject)
	local relpath = vim.fs.relpath(basecwd, filename)
	local baseDir = vim.split(relpath, "/", { trimempty = true })

	-- vim.notify(vim.inspect(baseDir))
	if baseDir[1]:match("%.Tests") == nil then
		baseDir[1] = baseDir[1] .. ".Tests"
		baseDir[#baseDir] = baseDir[#baseDir]:gsub("%.cs", "") .. "_Tests.cs"
	else
		baseDir[1] = baseDir[1]:gsub("%.Tests", "")
		baseDir[#baseDir] = baseDir[#baseDir]:gsub("_Tests.cs", "") .. ".cs"
	end

	local newpath = vim.fs.joinpath(basecwd, table.concat(baseDir, "/"))
	vim.cmd("e " .. newpath)
end)
