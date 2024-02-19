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

local function getOpts()
	local opts = {}

	opts.prompt = "Worktrees > "
	opts.fn_transform = function(x)
		return x + " trnitnr"
	end
	opts.actions = {
		["default"] = function(selected)
			vim.cmd("cd " .. selected[1])
		end,
	}

	return opts
end

require("fzf-lua").fzf_exec(getWorktreesAsync, getOpts())

-- :lua require'fzf-lua'.fzf_exec("ls", { prompt="LS> ", cwd="~/<folder>" })
