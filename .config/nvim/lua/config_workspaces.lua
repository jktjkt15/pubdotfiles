local ws = require("workspaces")

local firstLoad = true

ws.setup({
	hooks = {
		open = {
			function()
				require("config_autoload").load()
				local name = ws.name()
				vim.o.titlestring = string.format("%s (Neovim)", name)
				--
				-- vim.schedule(function()
				-- 	vim.fn.system({ "pwsh", "-c", string.format("$Host.UI.RawUI.WindowTitle = '%s'", name) })
				-- end)
			end,
		},
		open_pre = {
			function()
				if firstLoad then
					return
				end

				local bufs = vim.api.nvim_list_bufs()

				for _, bufnr in ipairs(bufs) do
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					local opts = {}

					if string.match(bufname, "^term://") then
						opts = { force = true }
					end

					vim.api.nvim_buf_delete(bufnr, opts)
				end
			end,
		},
	},
})

local lastWorkspaces = ws.get()

if firstLoad and lastWorkspaces ~= nil and lastWorkspaces[1] ~= nil and lastWorkspaces[1].name ~= nil then
	firstLoad = false

	if vim.v.argv[3] == "project" and #vim.v.argv > 3 then
		local targetProject = vim.v.argv[4]
		vim.schedule(function()
			ws.open(targetProject)
			vim.notify(string.format("Loaded %s", targetProject))
		end)
	end

	if #vim.v.argv > 2 then
		return
	end

	local mostRecentWorkspace = lastWorkspaces[1].name

	vim.schedule(function()
		ws.open(mostRecentWorkspace)
		vim.notify(string.format("Reloaded WS %s", mostRecentWorkspace))
	end)
end
