local function monkeyPatch(client)
	if not client.is_hacked_roslyn then
		client.is_hacked_roslyn = true

		-- let the runtime know the server can do semanticTokens/full now
		if client.server_capabilities.semanticTokensProvider then
			client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
				semanticTokensProvider = {
					full = true,
				},
			})
		end

		-- -- monkey patch the request proxy
		local request_inner = client.request
		client.request = function(method, params, handler, req_bufnr)
			if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
				return request_inner(method, params, handler, req_bufnr)
			end

			local function find_buf_by_uri(search_uri)
				local bufs = vim.api.nvim_list_bufs()
				for _, buf in ipairs(bufs) do
					local name = vim.api.nvim_buf_get_name(buf)
					local uri = "file://" .. name
					if uri == search_uri then
						return buf
					end
				end
			end

			local doc_uri = params.textDocument.uri

			local target_bufnr = find_buf_by_uri(doc_uri)
			local line_count = vim.api.nvim_buf_line_count(target_bufnr)
			local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

			return request_inner("textDocument/semanticTokens/range", {
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
end

require("roslyn").setup({
	config = {
		settings = {
			["csharp|background_analysis"] = {
				dotnet_analyzer_diagnostics_scope = "full_solution",
				dotnet_compiler_diagnostics_scope = "full_solution",
			},
		},
		on_attach = function(client)
			monkeyPatch(client)
		end,
	},
})
