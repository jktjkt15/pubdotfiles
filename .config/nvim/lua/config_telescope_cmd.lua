require("runcmd")
local telescope = require("telescope")

local function insert_at_cursor(lines)
	return vim.api.nvim_put(lines, "", false, true)
end

local function insert_date_str(format)
	return insert_at_cursor({ vim.fn.strftime(format) })
end

local function insert_uuid()
	return insert_at_cursor(vim.fn.systemlist("uuid | tr -d '\n'"))
end

vim.api.nvim_create_user_command("UUID", insert_uuid, {})

vim.g.runcmd_commands = {
	-- { name = "UUID", cmd = insert_uuid, description = "Insert UUID" },
	{
		name = "Date",
		cmd = function()
			insert_date_str("%Y-%m-%d")
		end,
		description = "Insert date",
	},
	{
		name = "Time",
		cmd = function()
			insert_date_str("%H:%M:%S")
		end,
		description = "Insert time",
	},
	{
		name = "Date Time",
		cmd = function()
			insert_date_str("%Y-%d-%m %H-%M-%S")
		end,
		description = "Insert date time",
	},
	{ name = "Git", cmd = "Git", description = "Open Git" },
	{
		name = "Lsp ->",
		cmd = function()
			local picker = require("runcmd.picker")
			picker.open({
				results = {
					{ name = "Start LSP", cmd = "LspStart", description = "start lsp" },
					{ name = "Stop LSP", cmd = "LspStop", description = "stop lsp" },
					{ name = "LSP Info", cmd = "LspInfo", description = "lsp info" },
				},
			})
		end,
		description = "Language Server commands",
	},
}

-- -- commands for specific filetype
-- vim.api.nvim_create_autocmd({ "FileType" }, {
-- 	pattern = { "ledger" },
-- 	callback = function()
-- 		vim.b.runcmd_commands = {
-- 			{
-- 				name = "Align Buffer",
-- 				cmd = "LedgerAlignBuffer",
-- 				description = "Aligns the commodity for each posting in the entire buffer",
-- 			},
-- 		}
-- 	end,
-- })

telescope.load_extension("runcmd")

vim.keymap.set("n", "<leader>cr", ":Telescope runcmd<cr>")
