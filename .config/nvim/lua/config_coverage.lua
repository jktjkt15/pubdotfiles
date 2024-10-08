-- local ns = vim.api.nvim_create_namespace("jay.coverage")
-- local ag = vim.api.nvim_create_augroup("jay.coverage.ag", { clear = true })
--
-- local currentCoverageStatus = ""
-- -- local currentCoverageJson = "{}"
--
-- local M = {
-- 	getCurrentCoverageJson = function()
-- 		return currentCoverageStatus
-- 	end,
-- 	-- TODO
-- 	-- add diags
-- }
--
-- local isRunning = false
--
-- local function findBaseProjectName()
-- 	local currentFolder = vim.fn.expand("%:h")
-- 	local targetFolder = vim.fs.root(currentFolder, function(name)
-- 		return name:match("%.csproj$") ~= nil
-- 	end)
--
-- 	return vim.fs.basename(targetFolder)
-- end
--
-- local function createDiags(json)
-- 	local filePathToBufName = {}
-- 	local targetBufNames = {}
--
-- 	local bufs = vim.api.nvim_list_bufs()
--
-- 	vim.diagnostic.reset(ns)
--
-- 	for _, item in ipairs(json) do
-- 		local name = item.FileName
--
-- 		if targetBufNames[name] == nil then
-- 			table.insert(targetBufNames, name)
-- 		end
-- 	end
--
-- 	for _, bufid in ipairs(bufs) do
-- 		local bufname = vim.api.nvim_buf_get_name(bufid)
--
-- 		if vim.api.nvim_buf_is_valid(bufid) and targetBufNames[bufname] ~= nil then
-- 			if filePathToBufName[bufname] == nil then
-- 				filePathToBufName[bufname] = { bufid = bufid, diags = {} }
-- 			end
-- 		end
-- 	end
--
-- 	for _, item in ipairs(json) do
-- 		local path = item.FullPath
--
-- 		if filePathToBufName[path] == nil then
-- 			local bufid = vim.api.nvim_create_buf(true, false)
--
-- 			vim.api.nvim_buf_call(bufid, function()
-- 				vim.cmd("e " .. item.FileName)
-- 			end)
--
-- 			filePathToBufName[path] = { bufid = bufid, diags = {} }
-- 			-- print(vim.inspect(filePathToBufName))
-- 		end
--
-- 		table.insert(filePathToBufName[path].diags, {
-- 			lnum = item.Line - 1,
-- 			bufrn = filePathToBufName[path].bufid,
-- 			col = 0,
-- 			severity = vim.diagnostic.severity.INFO,
-- 			-- message = "coverage: " .. item.LineRate * 100 .. "%",
-- 			message = "partial coverage",
-- 		})
-- 	end
--
-- 	for _, value in pairs(filePathToBufName) do
-- 		local bufid = value.bufid
-- 		local diags = value.diags
--
-- 		-- print(bufid)
-- 		-- print(diags)
-- 		-- vim.api.nvim_buf_clear_namespace(bufid, ns, 0, -1)
-- 		vim.diagnostic.set(ns, bufid, {}, {})
-- 		vim.diagnostic.set(ns, bufid, diags, {})
-- 	end
-- end
--
-- M.setup = function() end
--
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.cs" },
-- 	group = ag,
-- 	callback = function()
-- 		if isRunning then
-- 			return
-- 		end
--
-- 		currentCoverageStatus = "coverage running ..."
-- 		isRunning = true
--
-- 		local projectName = findBaseProjectName()
--
-- 		vim.system({ "pwsh", "-f", "coverage.ps1", projectName, "json" }, {
-- 			text = true,
-- 		}, function(obj)
-- 			if obj.code == 0 then
-- 				currentCoverageStatus = obj.stdout
--
-- 				vim.schedule(function()
-- 					local ok, json = pcall(vim.fn.json_decode, obj.stdout)
--
-- 					if not ok then
-- 						currentCoverageStatus = "error decoding coverage"
-- 						return
-- 					end
--
-- 					-- currentCoverageJson = json
--
-- 					if #json == 0 then
-- 						currentCoverageStatus = "perfect coverage!"
-- 					else
-- 						currentCoverageStatus = #json .. " line(s) with missing coverage"
-- 					end
--
-- 					createDiags(json)
-- 				end)
-- 			else
-- 				currentCoverageStatus = "failed build"
-- 			end
-- 		end)
--
-- 		isRunning = false
-- 	end,
-- })
--
-- -- local function applyDiags(bufid, json)
-- -- 	vim.api.nvim_buf_clear_namespace(bufid, ns, 0, -1)
-- -- 	vim.diagnostic.reset(ns, bufid)
-- --
-- -- 	local diagnostics = {}
-- -- 	local bufferPath = vim.api.nvim_buf_get_name(bufid)
-- --
-- -- 	for _, item in ipairs(json) do
-- -- 		if item.FullPath == bufferPath then
-- -- 			vim.api.nvim_buf_set_extmark(bufid, ns, item.Line - 1, 0, {
-- -- 				-- sign_text = "🫥",
-- -- 				sign_text = "A",
-- -- 			})
-- --
-- -- 			table.insert(diagnostics, {
-- -- 				lnum = item.Line - 1,
-- -- 				col = 0,
-- -- 				severity = vim.diagnostic.severity.INFO,
-- -- 				message = "coverage: " .. item.LineRate * 100 .. "%",
-- -- 				-- message = "📕",
-- -- 			})
-- -- 		end
-- --
-- -- 		vim.diagnostic.set(ns, bufid, diagnostics, {})
-- -- 	end
-- -- end
-- --
-- -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- -- 	pattern = { "*.cs" },
-- -- 	group = ag,
-- -- 	callback = function()
-- -- 		local ok, json = pcall(vim.fn.json_decode, currentCoverageJson)
-- --
-- -- 		if not ok then
-- -- 			return
-- -- 		end
-- --
-- -- 		for _, bufid in ipairs(bufs) do
-- -- 			if not vim.api.nvim_buf_is_loaded(bufid) then
-- -- 			end
-- --
-- -- 			applyDiags(bufid, json)
-- -- 		end
-- -- 	end,
-- -- })
-- -- end
--
-- return M
