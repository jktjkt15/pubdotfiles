vim.g.haskell_tools = {
	hls = {
		cmd = function()
			local path =
				"~/.local/share/nvim/mason/packages/haskell-language-server/bin/haskell-language-server-wrapper"
			-- .. "\\mason\\packages\\haskell-language-server\\haskell-language-server-wrapper.exe"

			return { path, "--lsp" }
		end,
	},
}

local tools = require("haskell-tools")

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.hs" },
	group = vim.api.nvim_create_augroup("Haskell", { clear = true }),
	callback = function(args)
		tools.lsp.start()
	end,
})

vim.keymap.set({ "n" }, "<localleader>r", function()
	tools.lsp.buf_eval_all()
end)
