local null_ls = require("null-ls")

local coverage_source = {
	multiple_files = true,
	method = null_ls.methods.DIAGNOSTICS,
}

local function findBaseProjectName(currentFolder)
	for dir in vim.fs.parents(currentFolder) do
		local findResults = vim.fs.find(function(name)
			return name:match(".*%.sln$")
		end, { limit = 1, type = "file", path = dir })

		if findResults ~= nil and #findResults > 0 then
			return vim.fs.basename(findResults[1]):gsub(".sln", "")
		end
	end

	return nil
end

coverage_source.generator = null_ls.generator({
	command = "pwsh",
	args = function(args)
		local name = vim.api.nvim_buf_get_name(args.bufnr)
		local rootProject = findBaseProjectName(name)

		return { "-f", "coverage.ps1", rootProject, "json" }
	end,
	-- to_stdin = true,
	-- from_stder",
	multiple_files = true,
	timeout = 20000,
	check_exit_code = function(code)
		return code == 0
	end,
	format = "json",
	on_output = function(arg)
		local diagnostics = {}
		local json = arg.output

		for _, v in ipairs(json) do
			table.insert(diagnostics, {
				row = tonumber(v.Line),
				filename = v.FullPath,
				col = 0,
				severity = vim.diagnostic.severity.INFO,
				message = "cov: " .. tonumber(v.LineRate) * 100 .. "%",
				-- message = "partial coverage",
			})
		end

		return diagnostics
	end,
})

null_ls.setup({
	debug = true,
})

null_ls.deregister(coverage_source)
-- null_ls.register({ name = "coverage", filetypes = { "cs" }, sources = { coverage_source } })
