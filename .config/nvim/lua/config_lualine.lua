local loadingDiags = false

local function FilteredDiags()
	if loadingDiags then
		return
	end

	loadingDiags = true

	local diags = vim.diagnostic.get()
	-- print(vim.inspect(diags))
	local filteredDiags = vim.tbl_filter(function(d)
		local bufname = vim.api.nvim_buf_get_name(d.bufnr)
		return not bufname:match(".*\\obj\\.*%.cs") and not bufname:match("\\.nuget\\")
	end, diags)
	local res = { ["1"] = 0, ["2"] = 0, ["3"] = 0, ["4"] = 0 }
	for _, v in ipairs(filteredDiags) do
		local severity = tostring(v.severity)
		res[severity] = res[severity] + 1
	end

	loadingDiags = false

	return { error = res["1"], warn = res["2"], info = res["3"], hint = res["4"] }
end

local function MacroDisplay()
	local register = vim.api.nvim_eval("reg_recording()")

	if register ~= "" then
		return "@" .. register
	end

	return register
end

local function LspInfo()
	local bufnr = vim.api.nvim_get_current_buf()
	local activeClients = vim.lsp.get_active_clients({ bufnr = bufnr })

	local res = vim.tbl_map(function(t)
		return t.name:gsub("[-_].*", ""):sub(1, 4)
	end, activeClients)

	return table.concat(res, ", ")
end

local function Todos()
	local numberedList = {}

	for index, value in ipairs(vim.g.jayTodos) do
		table.insert(numberedList, string.format("%i. %s", index, value))
	end

	local resultMessage = table.concat(numberedList, " ~ ")

	if resultMessage == "" then
		resultMessage = "No Todos"
	end

	return " " .. resultMessage
end

-- local function InSnippet()
-- 	local ls = require("luasnip")
--
-- 	if ls.in_snippet() then
-- 		return ""
-- 	end
--
-- 	return ""
-- end

local function CurrentWorkspace()
	local loaded, ws = pcall(require, "workspaces")

	if not loaded then
		return ""
	end

	local ok, wsName = pcall(ws.name)
	local result = ""

	if not ok or wsName == nil then
		result = "No Project: " .. vim.fn.getcwd()
	else
		result = string.format("%s", wsName)
	end

	return "󰷚 " .. result
end

local function ParseJsonPath()
	local ok, jsonPath = pcall(require, "jsonpath")
	if not ok then
		return ""
	end

	return jsonPath.get()
end

local function TreesitterContext()
	local buffer = vim.api.nvim_get_current_buf()
	local fileType = vim.api.nvim_get_option_value("ft", { buf = buffer })

	if not vim.tbl_contains({ "lua", "cs", "json" }, fileType) then
		return ""
	end

	if fileType == "json" then
		return ParseJsonPath()
	end

	local context = require("nvim-treesitter").statusline({
		type_patterns = { "class", "method", "function" },
		separator = " > ",
		transform_fn = function(line)
			local functionOnly = line:gsub("%b()", ""):gsub("[%(%{]", ""):gsub(";$", "")
			local portions = vim.split(functionOnly, " ", { trimempty = true })

			return portions[#portions]
		end,
	})

	if context ~= nil and context ~= "" then
		return "󰊕 " .. context
	end

	return ""
end

local function GetYamlSchemaName()
	local schema = require("yaml-companion").get_buf_schema(0)
	if schema.result[1].name == "none" then
		return ""
	end
	return "󰉪 " .. schema.result[1].name
end

local jayzoneColors = require("jayzone.colors")
require("lualine").setup({
	options = {
		theme = require("jayzone.lualine"),
		globalstatus = true,
		component_separators = { left = "|", right = "" },
	},
	sections = {
		lualine_a = {
			{
				"mode",
				color = { gui = "none" },
				fmt = function(str)
					return str --:sub(1, 3)
				end,
			},
		},
		lualine_b = {
			{
				"branch",
				fmt = function(str)
					return str:sub(1, 20)
				end,
			},
		},
		lualine_c = {
			"diff",
			{
				"diagnostics",
				-- symbols = { error = "E", warn = "W", info = "I", hint = "H" },
				always_visible = false,
				sources = { FilteredDiags },
			},
			Todos,
			MacroDisplay,
		},
		lualine_x = {
			"searchcount",
			{
				CurrentWorkspace,
				color = { fg = jayzoneColors.blue },
			},
			GetYamlSchemaName,
			"filetype",
		},
		lualine_y = {
			LspInfo,
			-- InSnippet,
		},
		lualine_z = {
			-- "location",
			{
				function()
					local date = os.date("%H:%M:%S")
					return string.format("%s", date)
				end,
				color = { gui = "none" },
			},
		},
	},
	winbar = {
		lualine_a = {},
		lualine_b = { CurrentWorkspace },
		lualine_c = {
			{
				TreesitterContext,
				color = { fg = jayzoneColors.blue },
			},
		},
		lualine_x = {
			{ "filetype", icon_only = true },
			{ "filename", path = 3 },
		},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {
			{ "filetype", icon_only = true },
			{ "filename", path = 0 },
		},
		lualine_y = {},
		lualine_z = {},
	},
})
