require("lspconfig.ui.windows").default_options.border = "double"

require("mason").setup({
    ui = {
        border = "double",
    },

    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
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
        "ols",
        "jsonls",
        "lemminx",
        "yamlls",
        "pyright",
        "zls",
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lsp_signature").setup({
    bind = true,
    doc_lines = 10,
    hint_enable = true,
    hint_prefix = "▫️",
    floating_window = true,
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

-- local elixir = require("elixir")
--
-- elixir.setup({
--     -- nextls = {
--     -- 	enable = false,
--     -- 	init_options = {
--     -- 		mix_env = "dev",
--     -- 		mix_target = "host",
--     -- 		experimental = {
--     -- 			completions = {
--     -- 				enable = false, -- control if completions are enabled. defaults to false
--     -- 			},
--     -- 		},
--     -- 	},
--     -- 	on_attach = function(client, bufnr) end,
--     -- 	capabilities = capabilities,
--     -- },
--     credo = { enable = false },
--     elixirls = {
--         enable = true,
--         settings = require("elixir.elixirls").settings({
--             dialyzerEnabled = false,
--             enableTestLenses = false,
--         }),
--         capabilities = capabilities,
--         -- on_attach = function(client, bufnr)
--         -- 	vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
--         -- 	vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
--         -- 	vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
--         -- end,
--     },
-- })
--
-- vim.lsp.enable('ionide')
-- vim.lsp.config('ionide', {
--     -- on_attach = on_attach,
--     capabilities = capabilities,
-- })

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--     pattern = "*.fs,*.fsx,*.fsi",
--     command = [[set filetype=fsharp]],
-- })

vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
    end,
})
vim.lsp.enable('ts_ls')

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

-- require("lspconfig").terraformls.setup({
--     on_attach = function(client)
--         client.server_capabilities.semanticTokensProvider = {}
--     end,
--     capabilities = capabilities,
-- })

-- require("lspconfig").powershell_es.setup({
-- 	capabilities = capabilities,
--     command = vim.fn.expand "$MASON/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1"
-- })

vim.lsp.config("powershell_es", {
    bundle_path = vim.fn.expand("$MASON/packages/powershell-editor-services"),
})
vim.lsp.enable('powershell_es')

vim.lsp.config('zls', {
    capabilities = capabilities,
})
vim.lsp.enable('zls')

vim.lsp.config('ols', {
    capabilities = capabilities,
})
vim.lsp.enable('ols')

-- require("lspconfig").roc_ls.setup({
--     capabilities = capabilities,
-- })
--
-- vim.filetype.add({ extension = { roc = "roc" } })

-- require("lspconfig").dockerls.setup({
--     capabilities = capabilities,
-- })

vim.lsp.config('jsonls', {
    capabilities = capabilities,
})
vim.lsp.enable('jsonls')

-- require("lspconfig").helm_ls.setup({
--     capabilities = capabilities,
--     settings = {
--         valuesFiles = {
--             mainValuesFile = "values.yaml",
--             lintOverlayValuesFile = "values.lint.yaml",
--             additionalValuesFilesGlobPattern = "values*.yaml",
--         },
--         ["helm-ls"] = {
--             yamlls = {
--                 enabled = true,
--                 diagnosticsLimit = 50,
--                 showDiagnosticsDirectly = false,
--                 path = "yaml-language-server",
--                 filetypes_exclude = { "helm" },
--                 config = {
--                     schemas = {
--                         kubernetes = "templates/**",
--                     },
--                     completion = true,
--                     hover = true,
--                     -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
--                 },
--             },
--         },
--     },
-- })

vim.lsp.config('gopls', {
    capabilities = capabilities,
})
vim.lsp.enable('gopls')

vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

vim.lsp.config('lemminx', {
    capabilities = capabilities,
})
vim.lsp.enable('lemminx')

vim.lsp.config('ocaml-lsp', {
    capabilities = capabilities,
})
vim.lsp.enable('ocaml-lsp')

-- local cfg = require("yaml-companion").setup()
vim.lsp.config('yamlls', {
    capabilities = capabilities,
})
vim.lsp.enable('yamlls')

-- {
-- 	capabilities = capabilities,
-- 	lspconfig = cfg.lspconfig,
-- }

vim.lsp.config('pyright', {
    capabilities = capabilities,
})
vim.lsp.enable('pyright')


vim.lsp.config('html', {
    capabilities = capabilities,
})
vim.lsp.enable('html')
