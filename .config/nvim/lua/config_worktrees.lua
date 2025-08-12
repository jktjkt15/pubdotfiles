local M = {}

M.Current = nil
M.CurrentWorktree = function()
	if M.Current == nil then
		return ""
	else
		return vim.fs.basename(M.Current)
	end
end

local newline = "\n"

local function parseWorktree(info)
	local worktreeLine = vim.fn.split(info, newline)[1]
	return vim.fn.split(worktreeLine, " ")[2]
end

local function callWorktrees(co, fzf_cb)
	vim.system({ "git", "worktree", "list", "--porcelain" }, {
		text = true,
	}, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				local info = vim.fn.split(obj.stdout, vim.fn.printf("%s%s", newline, newline), false)

				for _, value in ipairs(info) do
					fzf_cb(parseWorktree(value))
				end
			end

			coroutine.resume(co)
		end)
	end)
end

local function getWorktreesAsync(fzf_cb)
	return coroutine.wrap(function()
		local co = coroutine.running()

		callWorktrees(co, fzf_cb)

		coroutine.yield()

		fzf_cb()
	end)()
end

local function directory_exists(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory"
end

local function getOpts()
	local opts = {}

	opts.prompt = "Worktrees > "
	opts.actions = {
		["default"] = function(selected)
			-- print(vim.inspect(selected))

			if #selected > 0 then
				local path = selected[1]

				if directory_exists(path) then
					vim.cmd("cd " .. path)
					M.Current = path
				end
			end
		end,
	}

	return opts
end

vim.keymap.set("n", "<leader>fw", function()
	require("fzf-lua").fzf_exec(getWorktreesAsync, getOpts())
end, { desc = "Find worktrees" })

local function init()
	local cwd = vim.uv.cwd()

	vim.cmd("cd " .. cwd)

	getWorktreesAsync(function(wt)
		if wt == cwd then
			M.Current = wt
		end
	end)
end

vim.schedule(function()
	-- init()
end)

return M
