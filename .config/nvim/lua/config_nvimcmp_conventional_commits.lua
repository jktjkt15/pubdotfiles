local source = {}

local typesDict = {}

typesDict["build"] = {
	label = "build",
	documentation = "Changes that affect the build system or external dependencies",
}
typesDict["chore"] = {
	label = "chore",
	documentation = "Other changes that dont modify src or test files",
}
typesDict["ci"] = {
	label = "ci",
	documentation = "Changes to our CI configuration files and scripts",
}
typesDict["docs"] = {
	label = "docs",
	documentation = "Documentation only changes",
}
typesDict["feat"] = { label = "feat", documentation = "A new feature" }
typesDict["fix"] = { label = "fix", documentation = "A bug fix" }
typesDict["perf"] = {
	label = "perf",
	documentation = "A code change that improves performance",
}
typesDict["refactor"] = {
	label = "refactor",
	documentation = "A code change that neither fixes a bug nor adds a feature",
}
typesDict["revert"] = {
	label = "revert",
	documentation = "Reverts a previous commit",
}
typesDict["style"] = {
	label = "style",
	documentation = "Changes that do not affect the meaning of the code",
}
typesDict["test"] = {
	label = "test",
	documentation = "Adding missing tests or correcting existing tests",
}

function source.new()
	source.types = {
		typesDict["build"],
		typesDict["chore"],
		typesDict["ci"],
		typesDict["docs"],
		typesDict["feat"],
		typesDict["fix"],
		typesDict["perf"],
		typesDict["refactor"],
		typesDict["revert"],
		typesDict["style"],
		typesDict["test"],
	}

	-- source.scopes = {
	-- 	[1] = {
	-- 		label = "tirentiren",
	-- 	},
	-- }

	return setmetatable({}, { __index = source })
end

function source:is_available()
	return vim.bo.filetype == "gitcommit"
end

-- function source:get_keyword_pattern()
-- 	return [[\w\+]]
-- end

function source:get_trigger_characters()
	return { "(" }
end

local function candidates(entries)
	local items = {}
	for k, v in ipairs(entries) do
		items[k] = {
			label = v.label,
			kind = require("cmp").lsp.CompletionItemKind.Keyword,
			documentation = v.documentation,
		}
	end
	return items
end

local function scopeCandidates()
	local cwd = vim.uv.cwd()

	local scopesFile = vim.fs.joinpath(cwd, "scopes.json")
	local entries = {}

	if vim.fn.filereadable(scopesFile) == 1 then
		local json = vim.fn.readfile(scopesFile)
		local scopes = vim.fn.json_decode(json)

		for _, scope in pairs(scopes.scopes) do
			table.insert(entries, scope.name)
		end
	end

	local items = {}

	for k, v in ipairs(entries) do
		items[k] = { label = v, kind = require("cmp").lsp.CompletionItemKind.Module }
	end

	return items
end

function source:complete(request, callback)
	if
		request.context.option.reason == "manual"
		and request.context.cursor.row == 1
		and request.context.cursor.col == 1
	then
		callback({ items = candidates(self.types), isIncomplete = true })
	elseif
		request.context.option.reason == "auto"
		and request.context.cursor.row == 1
		and request.context.cursor.col == 2
	then
		callback({ items = candidates(self.types), isIncomplete = true })
	elseif request.context.cursor_before_line:sub(-1) == "(" and request.context.cursor.row == 1 then
		callback({ items = scopeCandidates(), isIncomplete = true })
	else
		callback()
	end
end

-- return source

if vim.g.cmp_conventionalcommits_source_id ~= nil then
	require("cmp").unregister_source(vim.g.cmp_conventionalcommits_source_id)
end

vim.g.cmp_conventionalcommits_source_id = require("cmp").register_source("conventionalcommits", source:new())
