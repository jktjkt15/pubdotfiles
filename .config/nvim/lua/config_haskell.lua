-- vim.g.haskell_tools = {
-- 	hls = {
-- 		cmd = function()
-- 			return { "haskell-language-server-wrapper", "--lsp" }
-- 		end,
-- 	},
-- }

vim.g.haskell_tools = {
	tools = { -- haskell-tools options
		log = {
			-- level = vim.log.levels.DEBUG,
		},
	},
}

local tools = require("haskell-tools")
-- --
-- -- vim.api.nvim_create_autocmd("BufWritePre", {
-- -- 	pattern = { "*.hs" },
-- -- 	group = vim.api.nvim_create_augroup("Haskell", { clear = true }),
-- -- 	callback = function(args)
-- -- 		tools.lsp.start()
-- -- 	end,
-- -- })
--
vim.keymap.set({ "n" }, "<localleader>r", function()
	tools.lsp.buf_eval_all()
end)
