local M = {}

local delimiter = "\t \t"

local function getProjects(co, cb)
	local mono = require("config_monorepo")
	local currentSubRepo = mono.GetCurrentSubRepo()
	local projPattern = mono.GetProjectPattern()

	local fdCmd = { "fd", projPattern, "-t", "f" }

	if currentSubRepo ~= "All" then
		table.insert(fdCmd, "--base-directory")
		table.insert(fdCmd, currentSubRepo)
	end

	vim.system(fdCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local projPaths = vim.fn.split(obj.stdout, "\n")

				cb(projPaths)
			end

			coroutine.resume(co)
		end)
	end)
end

local function getNugetPackages(co, query, cb)
	local getPackagesCmd = {
		"dotnet",
		"package",
		"search",
		"--format",
		"json",
		"--verbosity",
		"detailed",
		vim.fn.join(query, " "),
	}

	vim.system(getPackagesCmd, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local ok, json = pcall(vim.fn.json_decode, obj.stdout)

				if ok then
					local res = {}

					for _, source in ipairs(json.searchResult) do
						for _, line in ipairs(source.packages) do
							local entry = {
								id = line.id,
								["@type"] = "nuget",
								description = line.description,
								version = line.latestVersion,
								authors = { "" },
								totalDownloads = line.totalDownloads,
								source = string.format("[%s]", source.sourceName),
							}

							table.insert(res, entry)
						end
					end

					cb(res)
				else
					vim.notify("getNuget failed " .. json, vim.log.levels.ERROR, {})
				end
			end

			coroutine.resume(co)
		end)
	end)
end

local function searchNugets(query)
	return coroutine.wrap(function(fzf_cb)
		local co = coroutine.running()

		local nugets = {}

		getNugetPackages(co, query, function(packages)
			for _, nuget in ipairs(packages) do
				table.insert(nugets, nuget)
			end
		end)

		coroutine.yield()

		vim.schedule(function()
			for _, nuget in ipairs(nugets) do
				local entry = {
					nuget.id,
					nuget["@type"],
					-- "", --descriptions
					nuget.description:gsub("\r\n", ""):gsub("\n", ""),
					nuget.source,
					nuget.version,
					nuget.authors[1],
					nuget.totalDownloads,
				}

				local line = vim.fn.join(entry, delimiter)

				fzf_cb(line)
			end
			coroutine.resume(co)
		end)

		coroutine.yield()
		fzf_cb()
	end)
end

local builtin = require("fzf-lua.previewer.builtin")

local MyPreviewer = builtin.base:extend()

function MyPreviewer:new(o, opts, fzf_win)
	MyPreviewer.super.new(self, o, opts, fzf_win)
	setmetatable(self, MyPreviewer)
	return self
end

function MyPreviewer:populate_preview_buf(entry_str)
	local parts = vim.split(entry_str, delimiter, { trimempty = true })
	local document = {}

	local item = parts[1]
	local description = parts[3]
	-- local source = parts[4]
	-- local author = parts[6]

	if item ~= nil then
		table.insert(document, "# " .. item)
		table.insert(document, "")
		-- table.insert(document, "## From: " .. source)
		-- table.insert(document, "")
		-- table.insert(document, "## By: " .. author)
		-- table.insert(document, "")
		table.insert(document, "### Description:")
		table.insert(document, "")
		table.insert(document, description)
	end

	local tmpbuf = self:get_tmp_buffer()

	vim.api.nvim_set_option_value("ft", "markdown", { buf = tmpbuf, scope = "local" })
	vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, document)

	self:set_preview_buf(tmpbuf)
end

function MyPreviewer:gen_winopts()
	local new_winopts = {
		wrap = true,
		number = false,
	}

	return vim.tbl_extend("force", self.winopts, new_winopts)
end

local function getProjsOpts()
	return {
		prompt = "Projects > ",
		fzf_opts = {},
		actions = {
			["enter"] = function(selected)
				local cmd = vim.split(selected[1], " ", { trimempty = true })
				vim.system(cmd, { cwd = vim.uv.cwd() }, function(obj)
					vim.schedule(function()
						if obj.code == 0 then
							vim.notify(string.format("Installed %s in %s", cmd[5], cmd[3]))
						else
							vim.notify("Failed to install " .. cmd[5], vim.log.levels.ERROR)
						end
					end)
				end):wait()
			end,
		},
	}
end

local function getNugetOpts()
	return {
		prompt = "Nuget Packages > ",
		fzf_opts = {
			["--delimiter"] = delimiter,
			["--nth"] = "1",
			["--with-nth"] = "1,4,5",
			["--preview-window"] = "nohidden,right,50%",
		},
		query_delay = 300,
		previewer = MyPreviewer,
		actions = {
			["enter"] = function(selected)
				local itemParts = vim.split(selected[1], delimiter, { trimempty = true })
				local nuget = vim.fn.trim(itemParts[1])
				local version = vim.fn.trim(itemParts[5])

				require("fzf-lua").fzf_exec(function(fzf_cb)
					return coroutine.wrap(function()
						local co = coroutine.running()

						local projs = {}

						getProjects(co, function(v)
							projs = v
						end)

						coroutine.yield()

						local prefix = ""

						local currentSubRepo = require("config_monorepo").GetCurrentSubRepo()

						if currentSubRepo ~= "All" then
							prefix = currentSubRepo
						end

						for _, proj in pairs(projs) do
							local cmd =
								string.format("dotnet add %s/%s package -n %s -v %s", prefix, proj, nuget, version)
							vim.notify(string.format("running %s", cmd))
							fzf_cb(cmd)
						end

						coroutine.yield()
					end)()
				end, getProjsOpts())
			end,
		},
		func_async_callback = false,
	}
end

vim.keymap.set("n", "<leader>fn", function()
	require("fzf-lua").fzf_live(searchNugets, getNugetOpts())
end, { desc = "Search/Install Nugets" })

return M
