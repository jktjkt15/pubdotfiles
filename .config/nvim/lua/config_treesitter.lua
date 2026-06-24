-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- 	pattern = { "*.roc" },
-- 	command = "set filetype=roc",
-- })
--
-- -- add roc tree-sitter
-- local parsers = require("nvim-treesitter.parsers").get_parser_configs()
--
-- parsers.roc = {
-- 	install_info = {
-- 		url = "https://github.com/faldor20/tree-sitter-roc",
-- 		files = { "src/parser.c", "src/scanner.c" },
-- 	},
-- }

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"c_sharp",
		"dockerfile",
		-- "elixir",
		"fish",
		"fsharp",
		"gitcommit",
		"gitignore",
		"git_rebase",
		"go",
		"haskell",
		"hcl",
		"html",
		"hyprlang",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
        "odin",
		-- "proto",
		"python",
		"query",
		"razor",
		"sql",
        "ocaml",
		-- "templ",
		"typescript",
		"vim",
		"yaml",
        "zig"
	},
	callback = function()
		vim.treesitter.start()
	end,
})

require("nvim-treesitter").install({
	"bash",
	"c_sharp",
	"dockerfile",
	-- "elixir",
	"fish",
	"fsharp",
	"gitcommit",
	"gitignore",
	"git_rebase",
	"go",
	"haskell",
	"hcl",
	"html",
	"hyprlang",
	"javascript",
    "ocaml",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
    "odin",
	-- "proto",
	"python",
	"query",
	"razor",
	"sql",
	-- "templ",
	"typescript",
	"vim",
	"yaml",
    "zig"
})

-- require("nvim-treesitter-textobjects").setup({
-- 	select = {
--
-- 		-- Automatically jump forward to textobj, similar to targets.vim
-- 		lookahead = true,
--
-- 		keymaps = {
-- 			-- You can use the capture groups defined in textobjects.scm
-- 			-- ["ab"] = "@block.outer",
-- 			-- ["ib"] = "@block.inner",
-- 			["ap"] = "@parameter.outer",
-- 			["ip"] = "@parameter.inner",
-- 			["ai"] = "@call.outer",
-- 			["ii"] = "@call.inner",
-- 			["al"] = "@loop.outer",
-- 			["il"] = "@loop.inner",
-- 			["af"] = "@function.outer",
-- 			["if"] = "@function.inner",
-- 			["ac"] = "@class.outer",
-- 			["ic"] = "@class.inner",
-- 			["ab"] = "@object",
-- 		},
-- 		-- You can choose the select mode (default is charwise 'v')
-- 		selection_modes = {
-- 			-- ["@parameter.outer"] = "v", -- charwise
-- 			-- ["@function.outer"] = "V", -- linewise
-- 			-- ["@class.outer"] = "<c-v>", -- blockwise
-- 		},
-- 		-- If you set this to `true` (default is `false`) then any textobject is
-- 		-- extended to include preceding xor succeeding whitespace. Succeeding
-- 		-- whitespace has priority in order to act similarly to eg the built-in
-- 		-- `ap`.
-- 		include_surrounding_whitespace = false,
-- 	},
-- 	move = {
-- 		enable = true,
-- 		set_jumps = true, -- whether to set jumps in the jumplist
-- 		goto_next_start = {
-- 			["jf"] = "@function.outer",
-- 			["jc"] = "@class.outer",
-- 			["jp"] = "@parameter.inner",
-- 			["jb"] = "@object",
-- 		},
-- 		goto_next_end = {
-- 			["jef"] = "@function.outer",
-- 			["jec"] = "@class.outer",
-- 			["jep"] = "@parameter.inner",
-- 			["jeb"] = "@object",
-- 		},
-- 		goto_previous_start = {
-- 			["jF"] = "@function.outer",
-- 			["jC"] = "@class.outer",
-- 			["jB"] = "@object",
-- 		},
-- 		goto_previous_end = {
-- 			["jgF"] = "@function.outer",
-- 			["jgC"] = "@class.outer",
-- 			["jgP"] = "@parameter.inner",
-- 			["jgB"] = "@object",
-- 		},
-- 	},
-- })

vim.keymap.set({ "x", "o" }, "ap", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ip", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)

-- vim.treesitter.language.register("html", "xml")
vim.treesitter.language.register("hcl", { "tf", "terraform" })

-- goto_next_start = {
-- 	["jf"] = "@function.outer",
-- 	["jc"] = "@class.outer",
-- 	["jp"] = "@parameter.inner",
-- 	["jb"] = "@object",
-- },
-- goto_next_end = {
-- 	["jef"] = "@function.outer",
-- 	["jec"] = "@class.outer",
-- 	["jep"] = "@parameter.inner",
-- 	["jeb"] = "@object",
-- },
-- goto_previous_start = {
-- 	["jF"] = "@function.outer",
-- 	["jC"] = "@class.outer",
-- 	["jB"] = "@object",
-- },
-- goto_previous_end = {
-- 	["jgF"] = "@function.outer",
-- 	["jgC"] = "@class.outer",
-- 	["jgP"] = "@parameter.inner",
-- 	["jgB"] = "@object",
-- },

vim.keymap.set({ "n", "x", "o" }, "jf", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jef", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jF", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jc", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jec", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jC", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jp", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jep", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "jP", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
end)

-- vim.keymap.set({ "n", "x", "o" }, "]]", function()
--   require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
-- end)
-- -- You can also pass a list to group multiple queries.
-- vim.keymap.set({ "n", "x", "o" }, "]o", function()
--   require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
-- end)
-- -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
-- vim.keymap.set({ "n", "x", "o" }, "]s", function()
--   require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "]z", function()
--   require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
-- end)
--
-- vim.keymap.set({ "n", "x", "o" }, "]M", function()
--   require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "][", function()
--   require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
-- end)
--
-- vim.keymap.set({ "n", "x", "o" }, "[m", function()
--   require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "[[", function()
--   require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
-- end)
--
-- vim.keymap.set({ "n", "x", "o" }, "[M", function()
--   require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "[]", function()
--   require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
-- end)
--
-- -- Go to either the start or the end, whichever is closer.
-- -- Use if you want more granular movements
-- vim.keymap.set({ "n", "x", "o" }, "]d", function()
--   require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
-- end)
-- vim.keymap.set({ "n", "x", "o" }, "[d", function()
--   require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
-- end)

-- keymaps
vim.keymap.set("n", "<leader>a", function()
	require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end)
vim.keymap.set("n", "<leader>A", function()
	require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
end)
