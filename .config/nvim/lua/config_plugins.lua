local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		config = function()
			require("config_dadbod")
		end,
	},
	{
		"kndndrj/nvim-dbee",
		enabled = false,
		lazy = true,
		cmd = "Dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			require("config_dbee")
		end,
	},
	{
		"robitx/gp.nvim",
		event = "CmdlineEnter",
		config = function()
			require("config_gpt")
		end,
	},
	{
		"chrisgrieser/nvim-early-retirement",
		config = function()
			require("config_earlyretirement")
		end,
		event = "VeryLazy",
	},
	{
		"folke/flash.nvim",
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{
				"R",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			-- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
		config = function()
			require("config_flash")
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		keys = {
			{ "<leader>rp", "<leader>rp" },
			{ "<leader>rf", "<leader>rf" },
		},
		config = function()
			require("spectre").setup()

			vim.keymap.set("n", "<leader>rp", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			-- vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
			--     desc = "Search current word"
			-- })
			vim.keymap.set("v", "<leader>rp", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>rf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{
		"backdround/global-note.nvim",
		enabled = false,
		keys = {
			{
				"<leader>n",
				"<leader>n",
			},
		},
		config = function()
			local global_note = require("global-note")
			global_note.setup()

			vim.keymap.set("n", "<leader>n", global_note.toggle_note, {
				desc = "Toggle global note",
			})
		end,
	},
	-- {
	-- 	"mbbill/undotree",
	-- 	enabled = false,
	-- 	cmd = "UndotreeToggle",
	-- },
	{
		"towolf/vim-helm",
		ft = { "helm" },
	},
	{
		"ibhagwan/fzf-lua",
		-- enabled = false,
		event = "VeryLazy",
		config = function()
			require("config_fzf")
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		keys = {
			{
				"<leader>cb",
				function()
					require("nvim-highlight-colors").toggle()
				end,
			},
		},
	},
	{
		"jlcrochet/vim-razor",
		ft = { "razor" },
	},
	{
		"mfussenegger/nvim-lint",
		-- event = "BufEnter",
		ft = { "tf", "haskell" },
		config = function()
			require("config_lint")
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^3",
		config = function()
			require("config_haskell")
		end,
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
	},
	{
		"chrisgrieser/nvim-spider",
		-- event = "BufEnter",
		keys = {
			{ "w", "w" },
			{ "W", "W" },
			{ "b", "b" },
			{ "B", "B" },
		},
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("config_formatting")
		end,
	},
	{
		"johmsalas/text-case.nvim",
		event = "CmdlineEnter",
		-- cmd = "Sub",
		config = function()
			require("textcase").setup()
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = "ChatGPT",
		enabled = false,
		config = function()
			require("config_gen")
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"elixir-tools/elixir-tools.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvim-lua/plenary.nvim",
		},
		ft = { "exs", "ex", "elixir" },
	},
	{
		"seblj/roslyn.nvim",
		ft = { "cs" },
		config = function()
			require("config_lsp_roslyn")
		end,
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"chrisgrieser/nvim-genghis",
		-- event = "BufEnter",
		keys = {
			{ "<leader>yp", "<leader>yp" },
			{ "<leader>yn", "<leader>yn" },
			{ "<leader>ym", "<leader>ym" },
		},
		config = function()
			local genghis = require("genghis")
			vim.keymap.set("n", "<leader>yp", genghis.copyFilepath)
			vim.keymap.set("n", "<leader>yn", genghis.copyFilename)
			-- vim.keymap.set("n", "<leader>cx", genghis.chmodx)
			-- vim.keymap.set("n", "<leader>rf", genghis.renameFile)
			-- vim.keymap.set("n", "<leader>mf", genghis.moveAndRenameFile)
			-- vim.keymap.set("n", "<leader>nf", genghis.createNewFile)
			-- vim.keymap.set("n", "<leader>yf", genghis.duplicateFile)
			-- vim.keymap.set("n", "<leader>df", function () genghis.trashFile{trashLocation = "your/path"} end) -- default: "$HOME/.Trash".
			vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile)
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		lazy = true,
		event = { "BufReadPre E:/vault/**.md" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		config = function(_, opts)
			require("obsidian").setup(opts)

			vim.keymap.set("n", "gf", function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>ObsidianFollowLink<CR>"
				else
					return "gf"
				end
			end, { noremap = false, expr = true })
		end,
	},
	{
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>zt", "<leader>zt" },
			{ "<leader>zz", "<leader>zz" },
		},
		config = function()
			require("config_zen")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("config_lualine")
		end,
		dependencies = {
			-- "L3MON4D3/LuaSnip",
			"phelipetls/jsonpath.nvim",
		},
	},
	{
		"phelipetls/jsonpath.nvim",
		ft = { "json" },
	},
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		enabled = false,
	},
	{
		"stevearc/overseer.nvim",
		-- event = "VeryLazy",
		-- lazy = true,
		keys = {
			{ "<leader>pp", "<leader>pp" },
		},
		config = function()
			require("overseer").setup()
			vim.keymap.set("n", "<leader>pp", require("overseer").toggle)
		end,
	},
	{
		"natecraddock/workspaces.nvim",
		enabled = true,
		event = "VeryLazy",
		config = function()
			require("config_workspaces")
		end,
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		config = function()
			require("config_oil")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		-- event = "BufEnter",
		-- lazy = true,
		event = "VeryLazy",
		config = function()
			require("config_indent")
		end,
	},
	{
		"echasnovski/mini.notify",
		event = "VeryLazy",
		config = function()
			require("config_notify")
		end,
	},
	-- {
	-- 	"numToStr/Comment.nvim",
	-- 	-- event = "BufEnter",
	-- 	-- event = "VeryLazy",
	-- 	keys = {
	-- 		{ "gc", "gc" },
	-- 	},
	-- 	lazy = true,
	-- 	config = function()
	-- 		require("Comment").setup()
	-- 	end,
	-- },
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		config = function()
			require("nvim-web-devicons").setup({
				color_icons = false,
			})

			local defaultIcon = require("nvim-web-devicons").get_icon_by_filetype("cs", {})
			require("nvim-web-devicons").set_default_icon(defaultIcon, "#5a84e5", 0)
		end,
	},
	{
		"kylechui/nvim-surround",
		-- event = "BufEnter",
		event = "VeryLazy",
		-- lazy = true,
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "ys",
					normal_cur = "yss",
					normal_line = "yS",
					normal_cur_line = "ySS",
					visual = nil,
					visual_line = nil,
					delete = "ds",
					change = "cs",
					change_line = "cS",
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		-- event = "VeryLazy",
		cmd = "G",
		config = function()
			require("config_git")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		-- event = "BufEnter",
		event = "VeryLazy",
		-- lazy = true,
		config = function()
			require("config_gitsigns")
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffViewOpen",
		-- event = "BufEnter",
		config = function()
			require("diffview").setup()
		end,
	},
	-- {
	-- 	"startup-nvim/startup.nvim",
	-- 	enabled = false,
	-- 	config = function()
	-- 		require("config_startup")
	-- 	end,
	-- },
	{
		"OXY2DEV/markview.nvim",
		-- ft = "markdown",
		event = "VeryLazy",
		config = function()
			require("config_markview")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- event = "BufEnter",
		-- event = "VeryLazy",
		lazy = true,
		-- enabled = "false",
		-- commit = "c4f65272a971b9d5d6ac7ed4607e50dd6207923f",
		-- event = { "BufEnter", "CmdlineEnter" },
		config = function()
			require("config_treesitter")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
			-- {
			-- 	"yaocccc/nvim-hl-mdcodeblock.lua",
			-- 	enabled = false,
			-- 	config = function()
			-- 		require("hl-mdcodeblock").setup()
			-- 	end,
			-- },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		-- lazy = true,
		keys = {
			{ "<leader>ff", "<leader>ff" },
			{ "<leader>fcc", "<leader>fcc" },
			{ "<leader>fp", "<leader>fp" },
			{ "<leader>fb", "<leader>fb" },
			{ "<leader>fh", "<leader>fh" },
		},
		config = function()
			require("config_telescope")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"debugloop/telescope-undo.nvim",
			"siawkz/nvim-cheatsh",
		},
	},
	{
		"Wansmer/treesj",
		-- event = "BufEnter",
		keys = { { "<leader>jj", "<leader>jj" } },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				check_syntax_error = false,
				max_join_length = 1200,
			})

			vim.keymap.set("n", "<leader>jj", require("treesj").toggle)
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		-- event = "BufEnter",
		event = "VeryLazy",
		-- lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterViolet",
					"RainbowDelimiterBlue",
					"RainbowDelimiterYellow",
					"RainbowDelimiterCyan",
					"RainbowDelimiterRed",
					-- "RainbowDelimiterOrange",
					-- 'RainbowDelimiterGreen',
				},
			}
		end,
	},
	{
		"ggandor/leap.nvim",
		enabled = false,
		event = "BufEnter",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	-- {
	-- 	"tpope/vim-repeat",
	-- 	event = "BufEnter",
	-- },
	-- {
	-- 	"ggandor/flit.nvim",
	-- 	enabled = false,
	-- 	event = "BufEnter",
	-- 	config = function()
	-- 		require("flit").setup({
	-- 			keys = { f = "f", F = "F", t = "t", T = "T" },
	-- 			labeled_modes = "v",
	-- 			multiline = false,
	-- 			opts = {},
	-- 		})
	-- 	end,
	-- },
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
	},
	{
		"ThePrimeagen/harpoon",
		-- enabled = true,
		-- event = "VeryLazy",
		-- lazy = true,
		keys = {
			{ "<leader>a", "<leader>a" },
			{ "<leader>xa", "<leader>xa" },
			{ "<leader>xx", "<leader>xx" },
		},
		-- branch = "harpoon2",
		commit = "e76cb03",
		config = function()
			require("config_buffers")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"kana/vim-textobj-entire",
		event = "VeryLazy",
		-- lazy = true,
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	-- {
	-- 	"svermeulen/vim-easyclip",
	-- 	event = "BufEnter",
	-- 	enabled = false,
	-- 	config = function()
	-- 		vim.g.EasyClipPreserveCursorPositionAfterYank = 1
	-- 		vim.g.EasyClipEnableBlackHoleRedirect = 0
	-- 		vim.g.EasyClipEnableBlackHoleRedirectForChangeOperator = 0
	-- 	end,
	-- },
	{
		"vimwiki/vimwiki",
		enabled = false,
		keys = { "<leader>ww", "<leader>ww" },
	},
	{
		"stevearc/dressing.nvim",
		-- event = "BufEnter",
		-- lazy = true,
		event = "VeryLazy",
		config = function()
			require("config_dressing")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		config = function()
			require("config_nvimcmp")
		end,

		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,

		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			-- "hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"https://codeberg.org/FelipeLema/cmp-async-path",
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
			},

			-- "L3MON4D3/LuaSnip",
			-- "saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		lazy = true,
		config = function()
			require("config_copilot")
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "BufReadPre",
		-- ft = { "cs", "lua", "sql", "terraform" },
		build = ":MasonUpdate",
		config = function()
			require("config_lsp")
		end,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"Hoffs/omnisharp-extended-lsp.nvim",
			-- "jose-elias-alvarez/null-ls.nvim",
			"ray-x/lsp_signature.nvim",
			"someone-stole-my-name/yaml-companion.nvim",
			-- "lvimuser/lsp-inlayhints.nvim",
		},
	},
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		config = function()
			require("config_nonels")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"ionide/Ionide-vim",
		ft = { "fs", "fsharp" },
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"mfussenegger/nvim-dap",
		enabled = false,
		lazy = true,
		config = function()
			require("config_dap")
		end,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
		},
	},
	{
		"ariel-frischer/bmessages.nvim",
		cmd = "Bmessages",
		opts = {},
		-- event = "CmdlineEnter",
	},
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	event = "InsertEnter",
	-- 	-- lazy = false,
	-- 	-- priority = 998,
	-- 	enabled = false,
	-- 	version = "1.*",
	-- 	build = { "make install_jsregexp" },
	-- 	config = function()
	-- 		-- require("config_luasnip")
	-- 	end,
	-- },
	{
		"nguyenvukhang/nvim-toggler",
		-- event = "BufEnter",
		keys = {
			{ "<leader>ct", "<leader>ct" },
		},
		config = function()
			require("config_toggler")
		end,
	},
	{
		"jktjkt15/jayzone.nvim",
		lazy = false,
		priority = 1100,
		config = function()
			require("jayzone").setup({ name = "jayzone" })
			vim.cmd("hi Normal ctermbg=none guibg=none")
			vim.cmd("hi MiniNotifyNormal ctermbg=none guibg=none")
			-- vim.cmd("hi MiniNotifyTitle ctermbg=none guibg=none")
			-- vim.cmd("hi MiniNotifyBorder ctermbg=none guibg=none")
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		keys = {
			{ "<leader>cc", "<leader>cc" },
			{ "<leader>cp", "<leader>cp" },
		},
		config = function()
			vim.keymap.set("n", "<leader>cc", "<cmd>CccHighlighterToggle<cr>")
			vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>")
		end,
	},
	{
		"Ajnasz/telescope-runcmd.nvim",
		keys = {
			{ "<leader>cr", "<leader>cr" },
		},
		config = function()
			require("config_telescope_cmd")
		end,
	},
}, {
	dev = {
		path = "~/repos/plugins/",
	},
	ui = {
		border = "double",
	},
})
