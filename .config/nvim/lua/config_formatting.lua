local conform = require("conform")

conform.setup({
	-- Conform will run multiple formatters sequentially
	-- Use a sub-list to run only the first available formatter
	formatters_by_ft = {
		lua = { "stylua" },
		cs = { "csharpier" },
		fish = { "fish_indent" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		css = { "prettierd" },
	},
	format_on_save = {
		timeout_ms = 2500,
		lsp_fallback = false,
	},
	-- format_after_save = {
	-- 	lsp_fallback = false,
	-- },
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("NoBOM", { clear = true }),
	command = "set nobomb",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("LSPFormatter", { clear = true }),
	callback = function(args)
		conform.format({
			bufnr = args.buf,
		}, function()
			local bufnr = args.buf
			local formatters = conform.list_formatters(bufnr)

			-- vim.notify(vim.inspect(formatters))
			-- vim.notify(vim.inspect(conform.list_all_formatters()))
			--
			if #formatters > 0 then
				local formatterName = formatters[1].name
				vim.notify("Saved with " .. formatterName)
			else
				local clients = vim.lsp.get_clients({ bufnr = bufnr })

				if #clients > 0 then
					local clientName = clients[1].name
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == clientName
						end,
					})
					vim.notify("Saved with " .. clientName)
				end
			end
		end)
	end,
})
