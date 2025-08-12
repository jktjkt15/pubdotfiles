local M = {}

local newline = "\n"
local delimiter = "             "
local allRepos = "All"
local currentSubRepo = allRepos
local allProjects = "All"
local currentSubProject = allProjects
local basecwd = vim.uv.cwd()
local configFile = vim.fs.joinpath(vim.fn.stdpath("data"), "monorepo.json")

function M.GetCurrentSubRepo()
	return currentSubRepo
end

function M.GetCurrentSubProject()
	return currentSubProject
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

local function GetSavedRepoInfo()
	if vim.fn.filereadable(configFile) == 1 then
		local json = vim.fn.readfile(configFile)
		local config = vim.fn.json_decode(json)

		return config.projects[basecwd]
	end

	return nil
end

local function SaveRepoInfo()
	vim.notify(configFile)
	if not vim.uv.fs_stat(configFile) then
		local json = vim.fn.json_encode({ projects = {} })

		vim.fn.writefile({ json }, configFile, "b")
	end

	if vim.fn.filereadable(configFile) == 1 and vim.fn.filewritable(configFile) == 1 then
		local json = vim.fn.readfile(configFile)
		local config = vim.fn.json_decode(json)

		config.projects[basecwd] = { lastRepo = currentSubRepo, lastProject = currentSubProject }

		local newjson = vim.fn.json_encode(config)
		vim.fn.writefile({ newjson }, configFile, "b")
	else
		vim.notify("couldn't write repo info to " .. configFile)
	end
end

M.SetupDefaultProject = function()
	local pattern = M.GetSolutionPattern()

	vim.schedule(function()
		basecwd = vim.uv.cwd()

		vim.system({ "fd", pattern, "-d", "1" }, {
			text = true,
		}, function(obj)
			vim.uv.chdir(basecwd)

			if obj.code == 0 then
				if #obj.stdout > 1 then
					currentSubRepo = "."
				end
			end

			vim.schedule(function()
				local repoInfo = GetSavedRepoInfo()

				if repoInfo ~= nil then
					currentSubRepo = repoInfo.lastRepo
					currentSubProject = repoInfo.lastProject
				end
			end)
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

local function getSubProjects(co, cb)
	local pattern = M.GetProjectPattern()

	local fdCmd = { "fd", pattern, "-t", "f" }

	if currentSubRepo ~= allRepos then
		table.insert(fdCmd, "--base-directory")
		table.insert(fdCmd, currentSubRepo)
	end

	vim.system(fdCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local projectsPaths = vim.fn.split(obj.stdout, newline)
				local projectBaseFolders = {}

				for _, slnPath in ipairs(projectsPaths) do
					table.insert(projectBaseFolders, vim.fs.dirname(slnPath))
				end

				cb(projectBaseFolders)
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

				local subRepoParts = vim.split(currentSubRepo, "/", { trimempty = true })
				local subProjectParts = vim.split(currentSubProject, "/", { trimempty = true })

				for _, value in ipairs(items) do
					local filteredName = value

					if currentSubProject ~= allProjects then
						for _, p in pairs(subProjectParts) do
							filteredName = filteredName:gsub(p .. "/", "", 1)
						end
					end

					if currentSubRepo ~= allRepos and currentSubRepo ~= "." then
						for _, p in pairs(subRepoParts) do
							filteredName = filteredName:gsub(p .. "/", "", 1)
							filteredName = filteredName:gsub(p .. "/", "", 1)
						end
					end

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

local function getSubProjectsInFzf(fzf_cb)
	return coroutine.wrap(function()
		local co = coroutine.running()

		local subProjects = {}

		getSubProjects(co, function(v)
			subProjects = v
		end)

		coroutine.yield()

		fzf_cb("All")

		for _, subProject in ipairs(subProjects) do
			fzf_cb(subProject)
		end
		-- end

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

local function getFilesFromMonoRepoInFzf(fzf_cb, targetRepo, targetProject)
	return coroutine.wrap(function()
		local co = coroutine.running()

		local subRepos = {}
		local subProjects = {}

		getSubRepos(co, function(v)
			subRepos = v
		end)

		coroutine.yield()

		getSubProjects(co, function(v)
			subProjects = v
		end)

		coroutine.yield()

		local filteredFolders = {}

		local ignoreFolders = getIgnoreFolders()

		for _, ignoreFolder in pairs(ignoreFolders) do
			table.insert(subRepos, ignoreFolder)
		end

		for _, subRepo in ipairs(subRepos) do
			if targetRepo ~= allRepos and subRepo ~= targetRepo then
				table.insert(filteredFolders, subRepo)
			end
		end

		for _, subProject in ipairs(subProjects) do
			if targetProject ~= allProjects and subProject ~= targetProject then
				table.insert(filteredFolders, subProject)
			end
		end

		table.insert(filteredFolders, ".git")

		getSubFolders(co, fzf_cb, filteredFolders)

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
				if currentSubRepo ~= selected[1] then
					currentSubRepo = selected[1]
					currentSubProject = "All"
					SaveRepoInfo()
				end
			end,
		},
	}
end

local function getSubProjectsOpts()
	return {
		prompt = "Projects > ",
		winopts = { preview = { hidden = "hidden" } },
		actions = {
			["default"] = function(selected)
				if currentSubProject ~= selected[1] then
					currentSubProject = selected[1]
					SaveRepoInfo()
				end
			end,
		},
	}
end

vim.keymap.set("n", "<leader>fy", function()
	require("fzf-lua").fzf_exec(function(cb)
		getSubProjectsInFzf(cb)
	end, getSubProjectsOpts())
end, { desc = "Find SubProjects" })

vim.keymap.set("n", "<leader>fp", function()
	require("fzf-lua").fzf_exec(function(cb)
		getSubReposInFzf(cb)
	end, getSubReposOpts())
end, { desc = "Find SubRepos" })

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").fzf_exec(function(cb)
		getFilesFromMonoRepoInFzf(cb, currentSubRepo, currentSubProject)
	end, getFilesMonoRepoOpts())
end, { desc = "Find filtered files" })

vim.keymap.set("n", "<leader>d", function()
	local suffix = ""
	vim.fn.chdir(basecwd)

	if currentSubRepo ~= allRepos and currentSubProject ~= allProjects then
		if currentSubProject == allProjects then
			suffix = string.format('fish -C "cd %s"', currentSubRepo)
		else
			suffix = string.format('fish -C "cd %s"', currentSubProject)
		end
	elseif currentSubRepo ~= allRepos then
		suffix = string.format('fish -C "cd %s"', currentSubRepo)
	end

	return ":sp|te " .. suffix
end, { expr = true, desc = "Terminal prompt command" })

return M
