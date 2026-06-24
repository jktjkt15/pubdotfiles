local ts_query = [[
(class_declaration
  (modifier) @mod (#eq? @mod "static")
  body: (declaration_list
     (method_declaration
        (modifier) @m (#eq? @m "public")  
        returns: [
            (predefined_type) 
            (generic_name)
            (identifier)
        ] @r
        name: (identifier) @i
        parameters: (parameter_list) @p
     ) 
  )
) @class
]]

local ts = vim.treesitter
local jz = require("jayzone.colors").getColorScheme(vim.g.colors_name)
local ns = vim.api.nvim_create_namespace("mag_static_api")

vim.api.nvim_set_hl(0, "mag_static_api_bg", {
	bg = jz.dark_grey,
	fg = jz.very_bright_grey,
	italic = false,
	force = true,
})

local hl_line = vim.api.nvim_get_hl_id_by_name("mag_static_api_bg")

local enabled = true

local function show_api(source_buf)
	local parser = ts.get_parser(source_buf, "c_sharp", {})
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse("c_sharp", ts_query)

	local signatures = {}

	for _pattern, match, _metadata in query:iter_matches(root, source_buf, 0, -1) do
		local method_parts = {}
		local line = -1

		for id, nodes in pairs(match) do
			local name = query.captures[id]

			for _, node in ipairs(nodes) do
				method_parts[name] = ts.get_node_text(node, source_buf)

				line = node.start(node)
			end
		end

		local method_signature = string.format(
			"%s %s%s",
			method_parts["r"],
			method_parts["i"],
			method_parts["p"]:gsub("\n", ""):gsub("    ", "")
		)

		if line >= 0 then
			if signatures[line] == nil then
				signatures[line] = {}
			end

			table.insert(signatures[line], method_signature)
		end
	end

	vim.api.nvim_buf_clear_namespace(source_buf, ns, 0, -1)

	if not enabled then
		return
	end

	for line, signature_group in pairs(signatures) do
		local virt_lines = {}
		local max_len = -1

		for _, signature in pairs(signature_group) do
			local single_line = string.format(" ~ %s    ", signature)
			max_len = math.max(max_len, #single_line)
		end

		-- max_len = 100000
		for _, signature in pairs(signature_group) do
			local single_line = string.format("    %s", signature)
			local len = #single_line
			local pad_len = max_len - len
			local pad = string.rep(" ", pad_len)
			local result_line = string.format("%s%s", single_line, pad)

			table.insert(virt_lines, { { result_line, hl_line } })
		end

		vim.api.nvim_buf_set_extmark(source_buf, ns, line, 0, {
			id = line,
			virt_lines = virt_lines,
		})
	end
end

local augroup = vim.api.nvim_create_augroup("mag_static_api_au", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost" }, {
	pattern = { "*.cs" },
	group = augroup,
	callback = function(ev)
		show_api(ev.buf)
	end,
})

vim.keymap.set("n", "<leader>sx", function()
	enabled = not enabled
	vim.cmd("e")
end, { desc = "toggle public api" })
