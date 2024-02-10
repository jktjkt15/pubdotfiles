local M = {}

M.SubRepos = {}
M.CurrentSubRepo = ""

local newline = "\n"

local function getSubRepos(co, cb)
	local fdCmd = { "fd", ".sln", "-t", "f" }
	-- local fdCmd = { "fd", ".cabal", "-t", "f" }

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
	local fdCmd = { "fd", ".", "-t", "f", "-H", "--color=never" }

	for _, value in ipairs(folders) do
		table.insert(fdCmd, "-E")
		table.insert(fdCmd, value)
	end

	vim.system(fdCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				fzf_cb(obj.stdout)
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

		for _, subRepo in ipairs(subRepos) do
			fzf_cb(subRepo)
		end

		coroutine.yield()

		fzf_cb()
	end)()
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

		for _, subRepo in ipairs(subRepos) do
			if subRepo ~= targetRepo then
				table.insert(filteredRepos, subRepo)
			end
		end

		table.insert(filteredRepos, ".git")

		getSubFolders(co, fzf_cb, filteredRepos)

		coroutine.yield()

		fzf_cb()
	end)()
end

local function getFilesMonoRepoOpts()
	return {
		prompt = "Files > ",
		previewer = "builtin",
		actions = {
			["default"] = function(selected)
				vim.cmd("cd " .. selected[1])
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
				M.CurrentSubRepo = selected[1]
				print(M.CurrentSubRepo)
			end,
		},
	}
end

-- require("fzf-lua").fzf_exec(function(cb)
-- 	-- getSubReposInFzf(cb)
-- 	getFilesFromMonoRepoInFzf(cb, "OpenMeteoDownloader")
-- end, getFilesMonoRepoOpts())

require("fzf-lua").fzf_exec(function(cb)
	getSubReposInFzf(cb)
end, getSubReposOpts())

return M
