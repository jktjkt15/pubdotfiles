local conform = require("conform")

conform.setup({
	-- Conform will run multiple formatters sequentially
	-- Use a sub-list to run only the first available formatter
	formatters = {
		custom_csharpier = {
			command = "dotnet",
			-- inherit = false,
			args = function(self, ctx)
				local basePath = require("conform.util").root_file({ ".csharpierrc.yaml" })(self, ctx)
				local configPath = basePath .. "/.csharpierrc.yaml"

				return { "csharpier", "format", "$FILENAME", "--config-path", configPath }
			end,
			stdin = false,
		},
		custom_fantomas = {
			command = "dotnet",
			args = function()
				return { "fantomas", "$FILENAME" }
			end,
			stdin = false,
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		cs = { "custom_csharpier" },
		xml = { "custom_csharpier" },
		fish = { "fish_indent" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		css = { "prettierd" },
		go = { "gofmt" },
		fsharp = { "fantomas" },
		-- xml = { "xmlformat" },
		json = { "prettierd" },
		haskell = { "fourmolu" },
	},
	format_on_save = {
		timeout_ms = 20000,
		lsp_fallback = false,
	},
	-- format_after_save = {
	-- 	lsp_fallback = false,
	-- 	-- async = true,
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
						async = false,
						bufnr = bufnr,
						filter = function(client)
							return client.name == clientName
						end,
					})
					vim.notify("Saved with " .. clientName)
				end
			end
		end)
		-- vim.api.nvim_feedkeys("zz", "m", false)
	end,
})
