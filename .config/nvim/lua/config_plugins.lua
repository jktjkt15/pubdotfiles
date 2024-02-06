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
		event = "BufEnter",
		config = function()
			require("config_lint")
		end,
	},
	{
		"ThePrimeagen/git-worktree.nvim",
	},
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^3",
		config = function()
			require("config_haskell")
		end,
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
	},
	-- {
	-- 	"chrisgrieser/nvim-various-textobjs",
	-- 	event = "VeryLazy",
	-- 	enabled = false,
	-- 	config = function()
	-- 		require("various-textobjs").setup({
	-- 			useDefaultKeymaps = false,
	-- 		})
	-- 	end,
	-- },
	{
		"chrisgrieser/nvim-spider",
		event = "BufEnter",
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
		config = function()
			require("textcase").setup()
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = "ChatGPT",
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
	-- {
	-- 	"jmederosalvarado/roslyn.nvim",
	-- 	enabled = false,
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("config_lsp")
	-- 	end,
	-- },
	-- {
	-- 	"David-Kunz/gen.nvim",
	-- 	enabled = false,
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("config_gen")
	-- 	end,
	-- },
	{
		"chrisgrieser/nvim-genghis",
		event = "BufEnter",
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
		event = "BufEnter",
		config = function()
			require("config_lualine")
		end,
		dependencies = {
			-- "L3MON4D3/LuaSnip",
			"phelipetls/jsonpath.nvim",
		},
	},
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	},
	{
		"stevearc/overseer.nvim",
		-- event = "VeryLazy",
		lazy = true,
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
		event = "BufEnter",
		config = function()
			require("config_indent")
		end,
	},
	{
		"rcarriga/nvim-notify",
		enabled = false,
		event = "VeryLazy",
		config = function()
			require("config_notify")
		end,
	},
	{
		"echasnovski/mini.notify",
		-- event = "VeryLazy",
		config = function()
			require("config_notify")
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		config = function()
			require("Comment").setup()
		end,
	},
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
		event = "BufEnter",
		config = function()
			require("nvim-surround").setup()
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
		event = "BufEnter",
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
	{
		"startup-nvim/startup.nvim",
		enabled = false,
		config = function()
			require("config_startup")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- event = "VeryLazy",
		enabled = "false",
		-- event = { "BufEnter", "CmdlineEnter" },
		config = function()
			require("config_treesitter")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
			{
				"yaocccc/nvim-hl-mdcodeblock.lua",
				config = function()
					require("hl-mdcodeblock").setup()
				end,
			},
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
		},
		config = function()
			require("config_telescope")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"debugloop/telescope-undo.nvim",
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
		event = "BufEnter",
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
					"RainbowDelimiterOrange",
					-- 'RainbowDelimiterGreen',
				},
			}
		end,
	},
	{
		"ggandor/leap.nvim",
		event = "BufEnter",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"tpope/vim-repeat",
		event = "BufEnter",
	},
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
		enabled = true,
		event = "VeryLazy",
		branch = "harpoon2",
		config = function()
			require("config_buffers")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"kana/vim-textobj-entire",
		event = "BufEnter",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"svermeulen/vim-easyclip",
		event = "BufEnter",
		config = function()
			vim.g.EasyClipPreserveCursorPositionAfterYank = 1
		end,
	},
	{
		"vimwiki/vimwiki",
		enabled = false,
		keys = { "<leader>ww", "<leader>ww" },
	},
	{
		"stevearc/dressing.nvim",
		event = "BufEnter",
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
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			-- "L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
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
		"ionide/Ionide-vim",
		ft = { "fs", "fsharp" },
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"folke/neodev.nvim",
		-- priority = 999,
		ft = { "lua" },
		config = function()
			require("neodev").setup()
		end,
	},
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
		"AckslD/messages.nvim",
		enabled = false,
		cmd = "Messages",
		config = function()
			require("messages").setup()
		end,
	},
	{
		"ariel-frischer/bmessages.nvim",
		cmd = "Bmessages",
		opts = {},
		-- event = "CmdlineEnter",
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		-- lazy = false,
		-- priority = 998,
		version = "1.*",
		build = { "make install_jsregexp" },
		config = function()
			require("config_luasnip")
		end,
	},
	{
		"nguyenvukhang/nvim-toggler",
		event = "BufEnter",
		config = function()
			require("config_toggler")
		end,
	},
	{
		"jktjkt15/jayzone.nvim",
		lazy = false,
		priority = 1100,
		config = function()
			require("jayzone").setup()
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
		path = "E:/Repos/nvim/plugins",
	},
	ui = {
		border = "double",
	},
})
