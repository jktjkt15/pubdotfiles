require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"typescript",
		"hyprlang",
		"c_sharp",
		-- "f_sharp",
		"elixir",
		"yaml",
		"lua",
		"latex",
		"sql",
		"vim",
		"go",
		"proto",
		"latex",
		"python",
		"json",
		"haskell",
		"markdown",
		"markdown_inline",
		"hcl",
		"query",
		-- "rust",
		"html",
		"dockerfile",
		"gitcommit",
		"gitignore",
		"git_rebase",
		-- "help",
		"bash",
		"fish",
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = false, -- experimental
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				-- ["ab"] = "@block.outer",
				-- ["ib"] = "@block.inner",
				["ap"] = "@parameter.outer",
				["ip"] = "@parameter.inner",
				["ai"] = "@call.outer",
				["ii"] = "@call.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ab"] = "@object",
			},
			-- You can choose the select mode (default is charwise 'v')
			selection_modes = {
				-- ["@parameter.outer"] = "v", -- charwise
				-- ["@function.outer"] = "V", -- linewise
				-- ["@class.outer"] = "<c-v>", -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding xor succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			include_surrounding_whitespace = false,
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["jf"] = "@function.outer",
				["jc"] = "@class.outer",
				["jp"] = "@parameter.inner",
				["jb"] = "@object",
			},
			goto_next_end = {
				["jef"] = "@function.outer",
				["jec"] = "@class.outer",
				["jep"] = "@parameter.inner",
				["jeb"] = "@object",
			},
			goto_previous_start = {
				["jF"] = "@function.outer",
				["jC"] = "@class.outer",
				["jB"] = "@object",
			},
			goto_previous_end = {
				["jgF"] = "@function.outer",
				["jgC"] = "@class.outer",
				["jgP"] = "@parameter.inner",
				["jgB"] = "@object",
			},
		},
	},
	-- rainbow = {
	-- 	enable = true,
	-- 	query = "rainbow-parens",
	-- 	strategy = require("ts-rainbow").strategy.global,
	-- 	hlgroups = {
	-- 		-- "TSRainbowYellow",
	-- 		"TSRainbowViolet",
	-- 		-- "TSRainbowCyan",
	-- 		-- "TSRainbowRed",
	-- 		"TSRainbowBlue",
	-- 		"TSRainbowYellow",
	-- 		"TSRainbowCyan",
	-- 		"TSRainbowRed",
	-- 		"TSRainbowOrange",
	-- 	},
	-- },
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

vim.treesitter.language.register("html", "xml")
vim.treesitter.language.register("hcl", { "tf", "terraform" })

-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.fsharp = {
-- 	install_info = {
-- 		url = "C:\\Users\\jcapblancq\\AppData\\Local\\nvim-data\\tree-sitter-fsharp",
-- 		files = { "src/scanner.cc", "src/parser.c" },
-- 	},
-- 	filetype = "fsharp",
-- }
