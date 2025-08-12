local function monkey_patch_semantic_tokens(client)
	if client.is_hacked then
		return
	end
	client.is_hacked = true

	-- let the runtime know the server can do semanticTokens/full now
	client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
		semanticTokensProvider = {
			full = true,
		},
	})

	-- monkey patch the request proxy
	local request_inner = client.request
	function client:request(method, params, handler, req_bufnr)
		if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
			return request_inner(self, method, params, handler)
		end

		local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
		local line_count = vim.api.nvim_buf_line_count(target_bufnr)
		local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

		return request_inner(self, "textDocument/semanticTokens/range", {
			textDocument = params.textDocument,
			range = {
				["start"] = {
					line = 0,
					character = 0,
				},
				["end"] = {
					line = line_count - 1,
					character = string.len(last_line) - 1,
				},
			},
		}, handler, req_bufnr)
	end
end

require("roslyn").setup({
	config = {
		settings = {
			-- ["csharp|background_analysis"] = {
			-- 	-- dotnet_analyzer_diagnostics_scope = "fullSolution",
			-- 	-- dotnet_compiler_diagnostics_scope = "fullSolution",
			-- },
		},
		on_attach = function(client)
			monkey_patch_semantic_tokens(client)
		end,
	},
})
