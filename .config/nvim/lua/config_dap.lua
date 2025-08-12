local dap = require("dap")
local ui = require("dapui")
ui.setup()

local mason_registry = require("mason-registry")
local netcoredbg = mason_registry.get_package("netcoredbg") -- note that this will error if you provide a non-existent package name

-- print(netcoredbg:get_install_path())

local netcoredbg_debugger = vim.fn.exepath("netcoredbg")

if netcoredbg_debugger ~= "" then
	dap.adapters.coreclr = {
		type = "executable",
		command = netcoredbg_debugger,
		args = { "--interpreter=vscode" },
	}

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			-- projectDir = "${workspaceFolder}",
			-- program = function()
			--     -- print(vim.fn.getcwd() .. "/bin/debug/net7.0/CodeGenTester.dll")
			--     return vim.fn.getcwd() .. "/CodeGenTester/bin/Debug/net7.0/CodeGenTester.dll"
			--     -- return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
			-- end,
		},
	}
end

require("nvim-dap-virtual-text").setup({
	commented = true,
})

vim.keymap.set("n", "<leader><leader>l", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader><leader>e", dap.continue)
vim.keymap.set("n", "<leader><leader>n", dap.step_over)
vim.keymap.set("n", "<leader><leader>i", dap.step_into)
vim.keymap.set("n", "<leader><leader>t", dap.terminate)
vim.keymap.set("n", "<leader><leader>u", ui.toggle)
vim.keymap.set("n", "<leader><leader>r", dap.restart)
vim.keymap.set("n", "<leader><leader>o", function()
	ui.eval(nil, { enter = true })
end)

vim.keymap.set("n", "<leader><leader>s", function()
	local mono = require("config_monorepo")

	local subRepo = mono.GetCurrentSubRepo()
	local subProject = mono.GetCurrentSubProject()
	local projectPattern = mono.GetProjectPattern()
	local newline = "\n"

	if subRepo == "All" then
		subRepo = ""
	end
	if subProject == "All" then
		subProject = ""
	end

	local workingPath = vim.fs.joinpath(vim.uv.cwd(), subRepo, subProject)

	local function getSubReposInFzf(fzf_cb)
		return coroutine.wrap(function()
			local co = coroutine.running()
			local fdCmd = { "fd", projectPattern, "-t", "f" }

			vim.system(fdCmd, {
				text = true,
				cwd = workingPath,
			}, function(obj)
				vim.schedule(function()
					if obj.code == 0 then
						local paths = vim.fn.split(obj.stdout, newline)

						for _, path in ipairs(paths) do
							local dirpath = vim.fs.dirname(path)
							local fullpath = vim.fs.joinpath(workingPath, dirpath)
							fzf_cb(fullpath)
						end
					end

					coroutine.resume(co)
				end)
			end)

			coroutine.yield()
		end)()
	end

	local function getDllsInFzf(path, fzf_cb)
		return coroutine.wrap(function()
			local co = coroutine.running()
			local projectParts = vim.split(path, "/")
			local project = projectParts[#projectParts]
			local buildExitCode = 0

			vim.system({ "dotnet", "build", "--no-restore" }, { text = true, cwd = workingPath }, function(obj)
				buildExitCode = obj.code
				coroutine.resume(co)
			end)

			coroutine.yield()

			if buildExitCode ~= 0 then
				vim.notify("build failed!", vim.log.levels.ERROR)
			else
				local fdCmd = { "fd", project .. ".dll", "-t", "f" }
				local workingPath = vim.fs.joinpath(path, "bin", "Debug")

				vim.system(fdCmd, {
					text = true,
					cwd = workingPath,
				}, function(obj)
					vim.schedule(function()
						if obj.code == 0 then
							local paths = vim.fn.split(obj.stdout, newline)

							for _, path in ipairs(paths) do
								fzf_cb(vim.fs.joinpath(workingPath, path))
							end
						end

						coroutine.resume(co)
					end)
				end)

				coroutine.yield()
			end
		end)()
	end

	local function getDllsOpts()
		return {
			prompt = "Dlls > ",
			winopts = { preview = { hidden = "hidden" } },
			actions = {
				["default"] = function(selected)
					-- vim.schedule(function()
					vim.notify("running debugger on " .. selected[1])
					dap.run({
						type = "coreclr",
						request = "launch",
						name = ".net debug",
						program = selected[1],
					})
				end,
			},
		}
	end

	local function getSubReposOpts()
		return {
			prompt = "Projects > ",
			winopts = { preview = { hidden = "hidden" } },
			actions = {
				["default"] = function(selected)
					require("fzf-lua").fzf_exec(function(cb)
						getDllsInFzf(selected[1], cb)
					end, getDllsOpts())
				end,
			},
		}
	end

	require("fzf-lua").fzf_exec(function(cb)
		getSubReposInFzf(cb)
	end, getSubReposOpts())
end)

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
	vim.notify("finished debugging")
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
	vim.notify("finished debugging")
end
