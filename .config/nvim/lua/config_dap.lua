local dap = require("dap")

local mason_registry = require("mason-registry")
local netcoredbg = mason_registry.get_package("netcoredbg") -- note that this will error if you provide a non-existent package name

-- print(netcoredbg:get_install_path())

dap.adapters.coreclr = {
	type = "executable",
	command = netcoredbg:get_install_path() .. "/netcoredbg/netcoredbg.exe",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			-- print(vim.fn.getcwd() .. "/bin/debug/net7.0/CodeGenTester.dll")
			return vim.fn.getcwd() .. "/CodeGenTester/bin/Debug/net7.0/CodeGenTester.dll"
			-- return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}

require("nvim-dap-virtual-text").setup({
	-- commented = true,
})
