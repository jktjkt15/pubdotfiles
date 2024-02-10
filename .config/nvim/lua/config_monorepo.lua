local M = {}

-- local subRepos = {}

local newline = "\n"
local delimiter = "             "
local allRepos = "All"
local currentSubRepo = allRepos

function M.GetCurrentSubRepo()
	return currentSubRepo
end

function M.GetSolutionPattern()
	local pattern = ".sln"

	if vim.g.jay_sln_pattern ~= nil then
		pattern = vim.g.jay_sln_pattern
	end

	return pattern
end

M.GetProjectPattern = function()
	local pattern = ".csproj"

	if vim.g.jay_project_pattern ~= nil then
		pattern = vim.g.jay_project_pattern
	end

	return pattern
end

M.SetupDefaultProject = function()
	local pattern = M.GetSolutionPattern()

	vim.schedule(function()
		vim.system({ "fd", pattern, "-d", "1" }, {
			text = true,
		}, function(obj)
			if obj.code == 0 then
				if #obj.stdout > 1 then
					currentSubRepo = "."
				end
			end
		end)
	end)
end

local function getSubRepos(co, cb)
	local pattern = M.GetSolutionPattern()

	if vim.g.jay_pattern ~= nil then
		pattern = vim.g.jay_pattern
	end

	local fdCmd = { "fd", pattern, "-t", "f" }

	vim.system(fdCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local slnPaths = vim.fn.split(obj.stdout, newline)
				local slnBaseFolders = {}

				for _, slnPath in ipairs(slnPaths) do
					table.insert(slnBaseFolders, vim.fs.dirname(slnPath))
				end

				cb(slnBaseFolders)
			end

			coroutine.resume(co)
		end)
	end)
end

local function getSubFolders(co, fzf_cb, folders)
	local fdCmd = { "fd", ".", "-t", "f", "-H", "--color=always" }

	for _, value in ipairs(folders) do
		table.insert(fdCmd, "-E")
		table.insert(fdCmd, value)
	end

	vim.system(fdCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local items = vim.split(obj.stdout, newline, { trimempty = true })

				for _, value in ipairs(items) do
					local filteredName = value:gsub("^" .. currentSubRepo .. "/", "", 1)
					fzf_cb(value .. delimiter .. filteredName)
				end
			end

			coroutine.resume(co)
		end)
	end)
end

local function getSubReposInFzf(fzf_cb)
	return coroutine.wrap(function()
		local co = coroutine.running()

		local subRepos = {}

		getSubRepos(co, function(v)
			subRepos = v
		end)

		coroutine.yield()

		if #subRepos == 1 and subRepos[1] == "." then
			fzf_cb(".")
		else
			fzf_cb("All")

			for _, subRepo in ipairs(subRepos) do
				fzf_cb(subRepo)
			end
		end

		coroutine.yield()

		fzf_cb()
	end)()
end

local function getIgnoreFolders()
	local cwd = vim.uv.cwd()

	local scopesFile = vim.fs.joinpath(cwd, "scopes.json")
	local entries = {}

	if vim.fn.filereadable(scopesFile) == 1 then
		local json = vim.fn.readfile(scopesFile)
		local scopes = vim.fn.json_decode(json)

		if scopes.ignore then
			for _, ignoreFolder in pairs(scopes.ignore) do
				table.insert(entries, ignoreFolder)
			end
		end
	end

	return entries
end

local function getFilesFromMonoRepoInFzf(fzf_cb, targetRepo)
	return coroutine.wrap(function()
		local co = coroutine.running()

		local subRepos = {}

		getSubRepos(co, function(v)
			subRepos = v
		end)

		coroutine.yield()

		local filteredRepos = {}

		local ignoreFolders = getIgnoreFolders()

		for _, ignoreFolder in pairs(ignoreFolders) do
			table.insert(subRepos, ignoreFolder)
		end

		for _, subRepo in ipairs(subRepos) do
			if targetRepo ~= allRepos and subRepo ~= targetRepo then
				table.insert(filteredRepos, subRepo)
			end
		end

		table.insert(filteredRepos, ".git")

		getSubFolders(co, fzf_cb, filteredRepos)

		coroutine.yield()

		fzf_cb()
	end)()
end

local builtin = require("fzf-lua.previewer.builtin")

local MyPreviewer = builtin.buffer_or_file:extend()

function MyPreviewer:new(o, opts, fzf_win)
	MyPreviewer.super.new(self, o, opts, fzf_win)
	setmetatable(self, MyPreviewer)
	return self
end

function MyPreviewer:parse_entry(entry_str)
	local path = vim.split(entry_str, delimiter, { trimempty = true })[1]
	return {
		path = path,
	}
end

local function getFilesMonoRepoOpts()
	local pathGetter = function(selected)
		return vim.split(selected[1], delimiter, { trimempty = true })[1]
	end

	return {
		prompt = "Files > ",
		fzf_opts = {
			["--delimiter"] = delimiter,
			["--nth"] = "1",
			["--with-nth"] = "2",
			["--preview-window"] = "nohidden,right,50%",
			["--preview"] = {
				type = "cmd",
				fn = function(items)
					local item = vim.split(items[1], delimiter, { trimempty = true })[1]
					return string.format("bat --theme=base16  --style=plain --color=always %s", item)
				end,
			},
		},
		previewer = MyPreviewer,
		actions = {
			["default"] = function(selected)
				local path = pathGetter(selected)
				vim.cmd("e " .. path)
			end,
			["ctrl-v"] = function(selected)
				local path = pathGetter(selected)
				vim.cmd("vsp | e " .. path)
			end,
			["ctrl-h"] = function(selected)
				local path = pathGetter(selected)
				vim.cmd("sp | e " .. path)
			end,
		},
	}
end

local function getSubReposOpts()
	return {
		prompt = "Repos > ",
		winopts = { preview = { hidden = "hidden" } },
		actions = {
			["default"] = function(selected)
				currentSubRepo = selected[1]
			end,
		},
	}
end

vim.keymap.set("n", "<leader>fp", function()
	require("fzf-lua").fzf_exec(function(cb)
		getSubReposInFzf(cb)
	end, getSubReposOpts())
end, { desc = "Find SubRepos" })

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").fzf_exec(function(cb)
		getFilesFromMonoRepoInFzf(cb, currentSubRepo)
	end, getFilesMonoRepoOpts())
end, { desc = "Find SubRepos" })

vim.keymap.set("n", "<leader>d", function()
	local suffix = ""

	if currentSubRepo ~= allRepos then
		suffix = string.format('fish -C "cd %s"', currentSubRepo)
	end

	return ":sp|te " .. suffix
end, { expr = true, desc = "Terminal prompt command" })

return M
