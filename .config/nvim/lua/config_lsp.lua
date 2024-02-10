require("lspconfig.ui.windows").default_options.border = "double"

require("mason").setup({
	ui = {
		border = "double",
	},
})

vim.keymap.set("n", "<leader>i", "<cmd>Inspect<cr>")

require("mason-lspconfig").setup({
	ensure_installed = {
		"ts_ls",
		-- "omnisharp",
		-- "csharp_ls",
		"terraformls",
		"lua_ls",
		"helm_ls",
		"powershell_es",
		"dockerls",
		-- "hls",
		"gopls",
		-- "elixirls",
		-- "nextls",
		"jsonls",
		"lemminx",
		"yamlls",
		"pyright",
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lsp_signature").setup({
	hint_enable = true,
	hint_prefix = "▫️",
	floating_window = false,
	hint_inline = function()
		return false
	end,
})

-- vim.keymap.set({ "n" }, "<leader>kk", function()
-- 	require("lsp_signature").toggle_float_win()
-- end, { silent = true, noremap = true, desc = "toggle signature" })

-- vim.keymap.set({ "n" }, "K", function()
-- 	-- require("lsp_signature").toggle_float_win()
-- 	vim.lsp.buf.signature_help()
-- end, { silent = true, noremap = true, desc = "toggle signature" })

local elixir = require("elixir")

elixir.setup({
	-- nextls = {
	-- 	enable = false,
	-- 	init_options = {
	-- 		mix_env = "dev",
	-- 		mix_target = "host",
	-- 		experimental = {
	-- 			completions = {
	-- 				enable = false, -- control if completions are enabled. defaults to false
	-- 			},
	-- 		},
	-- 	},
	-- 	on_attach = function(client, bufnr) end,
	-- 	capabilities = capabilities,
	-- },
	credo = { enable = false },
	elixirls = {
		enable = true,
		settings = require("elixir.elixirls").settings({
			dialyzerEnabled = false,
			enableTestLenses = false,
		}),
		capabilities = capabilities,
		-- on_attach = function(client, bufnr)
		-- 	vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
		-- 	vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
		-- 	vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
		-- end,
	},
})

require("ionide").setup({
	-- on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		FSharp = {
			Linter = true,
		},
	},
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.fs,*.fsx,*.fsi",
	command = [[set filetype=fsharp]],
})

require("lspconfig").ts_ls.setup({
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
	end,
})

-- require("lspconfig").omnisharp.setup({
-- 	on_attach = function(client)
-- 		client.server_capabilities.documentFormattingProvider = false
-- 	end,
-- 	capabilities = capabilities,
-- 	handlers = {
-- 		["textDocument/definition"] = require("omnisharp_extended").handler,
-- 	},
-- })

-- require("lspconfig").csharp_ls.setup({
-- 	on_attach = function(client)
-- 		client.server_capabilities.documentFormattingProvider = false
-- 	end,
-- 	capabilities = capabilities,
-- })

-- require("lspconfig").hls.setup({
-- 	capabilities = capabilities,
-- 	on_attach = function(client)
-- 		client.server_capabilities.documentFormattingProvider = false
-- 	end,
-- })

require("lspconfig").terraformls.setup({
	on_attach = function(client)
		client.server_capabilities.semanticTokensProvider = {}
	end,
	capabilities = capabilities,
})

require("lspconfig").powershell_es.setup({
	capabilities = capabilities,
	on_attach = function(client)
		-- client.server_capabilities.semanticTokensProvider = {}
		-- print("testesete")
	end,
})

require("lspconfig").dockerls.setup({
	capabilities = capabilities,
})

require("lspconfig").jsonls.setup({
	capabilities = capabilities,
})

require("lspconfig").helm_ls.setup({
	capabilities = capabilities,
	settings = {
		valuesFiles = {
			mainValuesFile = "values.yaml",
			lintOverlayValuesFile = "values.lint.yaml",
			additionalValuesFilesGlobPattern = "values*.yaml",
		},
		["helm-ls"] = {
			yamlls = {
				enabled = true,
				diagnosticsLimit = 50,
				showDiagnosticsDirectly = false,
				path = "yaml-language-server",
				filetypes_exclude = { "helm" },
				config = {
					schemas = {
						kubernetes = "templates/**",
					},
					completion = true,
					hover = true,
					-- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
				},
			},
		},
	},
})

require("lspconfig").gopls.setup({
	capabilities = capabilities,
})

require("lspconfig").lua_ls.setup({
	on_attach = function(client)
		-- vim.notify_once(vim.inspect(client.server_capabilities))
		client.server_capabilities.documentFormattingProvider = false
	end,
	capabilities = capabilities,
	settings = {
		Lua = {
			hint = {
				enable = true,
			},
			diagnostics = {
				globals = { "vim" },
			},
			completion = {
				callSnippet = "Replace",
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})

require("lspconfig").lemminx.setup({
	capabilities = capabilities,
})

local cfg = require("yaml-companion").setup()
require("lspconfig").yamlls.setup(cfg)
-- {
-- 	capabilities = capabilities,
-- 	lspconfig = cfg.lspconfig,
-- }

require("lspconfig").pyright.setup({
	capabilities = capabilities,
})
