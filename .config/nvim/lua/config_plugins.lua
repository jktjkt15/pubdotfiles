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
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>ya",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
		},
		opts = {
			open_for_directories = true,
		},
	},
	{
		"mikesmithgh/kitty-scrollback.nvim",
		enabled = true,
		lazy = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		config = function()
			require("kitty-scrollback").setup()
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		config = function()
			require("git-conflict").setup()
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		enabled = false,
		config = function()
			require("config_codecompanion")
		end,
	},
	{
		"hat0uma/csvview.nvim",
		opts = {
			parser = { comments = { "#", "//" } },
			view = {
				display_mode = "highlight",
			},
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.
				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				-- jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				-- jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				-- jump_next_row = { "<Enter>", mode = { "n", "v" } },
				-- jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},
	{
		"willothy/flatten.nvim",
		config = true,
		lazy = false,
		priority = 2000,
	},
	{
		"stevearc/resession.nvim",
		enabled = true,
		lazy = true,
		config = function()
			require("config_session")
		end,
	},
	{
		"pteroctopus/faster.nvim",
		enabled = false,
		config = function()
			require("config_bigfiles")
		end,
	},
	{
		"rbong/vim-flog",
		cmd = { "Flog" },
		dependencies = {
			{ "tpope/vim-fugitive" },
		},
		lazy = true,
	},
	{
		"folke/todo-comments.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		config = function()
			require("config_dadbod")
		end,
	},
	-- TODO: test code companion
	{
		"robitx/gp.nvim",
		event = "CmdlineEnter",
		keys = {
			{ "<leader>gc", "<leader>gc" },
			{ "<leader>gn", "<leader>gn" },
			{ "<leader>gt", "<leader>gt" },
		},
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
			{
				"R",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
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
			vim.keymap.set("v", "<leader>rp", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("n", "<leader>rf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
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
		enabled = false,
	},
	{
		"mfussenegger/nvim-lint",
		ft = { "tf", "haskell" },
		config = function()
			require("config_lint")
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		enabled = true,
		config = function()
			require("config_haskell")
		end,
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "w" },
			{ "W", "W" },
			{ "b", "b" },
			{ "B", "B" },
		},
		commit = "be2ad40",
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
		"elixir-tools/elixir-tools.nvim",
		ft = { "exs", "ex", "elixir" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"seblj/roslyn.nvim",
		ft = { "cs" },
		-- commit = "0dff8e3b5692e6ead592bba584efdf3e8073ab7b",
		config = function()
			require("config_lsp_roslyn")
		end,
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	{
		"chrisgrieser/nvim-genghis",
		event = "VeryLazy",
		keys = {
			{ "<leader>yp", "<leader>yp" },
			{ "<leader>yn", "<leader>yn" },
			{ "<leader>ym", "<leader>ym" },
		},
		config = function()
			local genghis = require("genghis")
			vim.keymap.set("n", "<leader>yp", genghis.copyFilepath)
			vim.keymap.set("n", "<leader>yn", genghis.copyFilename)
			vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile)
			-- vim.keymap.set("n", "<leader>cx", genghis.chmodx)
			vim.keymap.set("n", "<leader>yr", genghis.renameFile)
			-- vim.keymap.set("n", "<leader>mf", genghis.moveAndRenameFile)
			-- vim.keymap.set("n", "<leader>nf", genghis.createNewFile)
			vim.keymap.set("n", "<leader>yc", genghis.duplicateFile)
			-- vim.keymap.set("n", "<leader>df", function () genghis.trashFile{trashLocation = "your/path"} end) -- default: "$HOME/.Trash".
			vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile, { desc = "Move selection to new file" })
		end,
	},
	-- {
	-- 	"epwalsh/obsidian.nvim",
	-- 	ft = { "markdown" },
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"hrsh7th/nvim-cmp",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("obsidian").setup({
	-- 			workspaces = {
	-- 				{
	-- 					name = "work",
	-- 					path = "~/.config/vault",
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		vim.keymap.set("n", "gf", function()
	-- 			if require("obsidian").util.cursor_on_markdown_link() then
	-- 				return "<cmd>ObsidianFollowLink<CR>"
	-- 			else
	-- 				return "gf"
	-- 			end
	-- 		end, { noremap = false, expr = true })
	-- 	end,
	-- },
	{
<<<<<<< HEAD
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
		enabled = false,
	},
	{
		"ibhagwan/fzf-lua",
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
||||||| parent of 3a22224 (feat: big neovim update)
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
			enabled = false,
		},
		{
			"ibhagwan/fzf-lua",
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
			enabled = false,
		},
		{
			"mfussenegger/nvim-lint",
			ft = { "tf", "haskell" },
			config = function()
				require("config_lint")
			end,
		},
		{
			"mrcjkb/haskell-tools.nvim",
			enabled = true,
			config = function()
				require("config_haskell")
			end,
			ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
		},
		{
			"chrisgrieser/nvim-spider",
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
			config = function()
				require("textcase").setup()
			end,
		},
		{
			"elixir-tools/elixir-tools.nvim",
			ft = { "exs", "ex", "elixir" },
			dependencies = {
				"williamboman/mason.nvim",
				"nvim-lua/plenary.nvim",
			},
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
			event = "VeryLazy",
			keys = {
				{ "<leader>yp", "<leader>yp" },
				{ "<leader>yn", "<leader>yn" },
				{ "<leader>ym", "<leader>ym" },
			},
			config = function()
				local genghis = require("genghis")
				vim.keymap.set("n", "<leader>yp", genghis.copyFilepath)
				vim.keymap.set("n", "<leader>yn", genghis.copyFilename)
				vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile)
				-- vim.keymap.set("n", "<leader>cx", genghis.chmodx)
				-- vim.keymap.set("n", "<leader>rf", genghis.renameFile)
				-- vim.keymap.set("n", "<leader>mf", genghis.moveAndRenameFile)
				-- vim.keymap.set("n", "<leader>nf", genghis.createNewFile)
				-- vim.keymap.set("n", "<leader>yf", genghis.duplicateFile)
				-- vim.keymap.set("n", "<leader>df", function () genghis.trashFile{trashLocation = "your/path"} end) -- default: "$HOME/.Trash".
				vim.keymap.set(
					"x",
					"<leader>ym",
					genghis.moveSelectionToNewFile,
					{ desc = "Move selection to new file" }
				)
			end,
		},
		{
			"epwalsh/obsidian.nvim",
			ft = { "markdown" },
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				require("obsidian").setup({
					workspaces = {
						{
							name = "work",
							path = "~/.config/vault",
						},
					},
				})

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
				{
					"phelipetls/jsonpath.nvim",
					ft = { "json" },
				},
			},
		},
		{
			"stevearc/overseer.nvim",
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
			event = "VeryLazy",
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
			cmd = "G",
			config = function()
				require("config_git")
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			event = "VeryLazy",
			config = function()
				require("config_gitsigns")
			end,
		},
		{
			"sindrets/diffview.nvim",
			cmd = "DiffViewOpen",
			config = function()
				require("diffview").setup()
			end,
		},
		{
			"OXY2DEV/markview.nvim",
			ft = "markdown",
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
			lazy = true,
			config = function()
				require("config_treesitter")
			end,
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/playground",
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			lazy = true,
			config = function()
				require("config_telescope")
			end,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"debugloop/telescope-undo.nvim",
				-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				-- "siawkz/nvim-cheatsh",
			},
		},
		{
			"Wansmer/treesj",
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
			event = "VeryLazy",
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
			"akinsho/toggleterm.nvim",
			lazy = true,
		},
		{
			"ThePrimeagen/harpoon",
			keys = {
				{ "<leader>a", "<leader>a" },
				{ "<leader>xa", "<leader>xa" },
				{ "<leader>xx", "<leader>xx" },
				{ "<leader>1", "<leader>1" },
				{ "<leader>2", "<leader>2" },
				{ "<leader>3", "<leader>3" },
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
			dependencies = {
				"kana/vim-textobj-user",
			},
		},
		{
			"stevearc/dressing.nvim",
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
				"hrsh7th/cmp-cmdline",
				-- "PasiBergman/cmp-nuget",
				"https://codeberg.org/FelipeLema/cmp-async-path",
				{
					"zbirenbaum/copilot-cmp",
					config = function()
						require("copilot_cmp").setup()
					end,
				},
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
			event = "VeryLazy",
			build = ":MasonUpdate",
			config = function()
				require("config_lsp")
			end,
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				"neovim/nvim-lspconfig",
				"ray-x/lsp_signature.nvim",
				{
					"someone-stole-my-name/yaml-companion.nvim",
					ft = { "yaml", "yml" },
				},
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
			dependencies = {
				{ "Bilal2453/luvit-meta", lazy = true },
			},
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
			"ariel-frischer/bmessages.nvim",
			cmd = "Bmessages",
			opts = {},
		},
		{
			"nguyenvukhang/nvim-toggler",
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
				vim.cmd("hi WinBar ctermbg=none guibg=none")
				vim.cmd("hi WinBarNC ctermbg=none guibg=none")
			end,
		},
		{
			"uga-rosa/ccc.nvim",
			enabled = false,
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
			enabled = false,
			keys = {
				{ "<leader>cr", "<leader>cr" },
			},
			config = function()
				require("config_telescope_cmd")
			end,
		},
		{
			"jay/local.nvim",
			event = "VeryLazy",
			dev = true,
			config = function()
				require("config_replace")
				require("config_clipboard")
				require("config_autoload")
				require("config_keymaps")
				require("config_codeautomation")
				require("config_note")
				require("config_worktrees")
				require("config_monorepo")
				require("config_buildtester")
				require("config_dotnet")
			end,
=======
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
			{
				"phelipetls/jsonpath.nvim",
				ft = { "json" },
			},
>>>>>>> 3a22224 (feat: big neovim update)
		},
	},
	{
<<<<<<< HEAD
		"jlcrochet/vim-razor",
		ft = { "razor" },
		enabled = false,
	},
	{
		"mfussenegger/nvim-lint",
		ft = { "tf", "haskell" },
		config = function()
			require("config_lint")
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		enabled = true,
		config = function()
			require("config_haskell")
		end,
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "w" },
			{ "W", "W" },
			{ "b", "b" },
			{ "B", "B" },
||||||| parent of 3a22224 (feat: big neovim update)
		dev = {
			path = "~/repos/plugins/",
=======
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>pp", "<leader>pp" },
>>>>>>> 3a22224 (feat: big neovim update)
		},
<<<<<<< HEAD
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
		"elixir-tools/elixir-tools.nvim",
		ft = { "exs", "ex", "elixir" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvim-lua/plenary.nvim",
		},
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
		event = "VeryLazy",
		keys = {
			{ "<leader>yp", "<leader>yp" },
			{ "<leader>yn", "<leader>yn" },
			{ "<leader>ym", "<leader>ym" },
		},
		config = function()
			local genghis = require("genghis")
			vim.keymap.set("n", "<leader>yp", genghis.copyFilepath)
			vim.keymap.set("n", "<leader>yn", genghis.copyFilename)
			vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile)
			-- vim.keymap.set("n", "<leader>cx", genghis.chmodx)
			-- vim.keymap.set("n", "<leader>rf", genghis.renameFile)
			-- vim.keymap.set("n", "<leader>mf", genghis.moveAndRenameFile)
			-- vim.keymap.set("n", "<leader>nf", genghis.createNewFile)
			-- vim.keymap.set("n", "<leader>yf", genghis.duplicateFile)
			-- vim.keymap.set("n", "<leader>df", function () genghis.trashFile{trashLocation = "your/path"} end) -- default: "$HOME/.Trash".
			vim.keymap.set("x", "<leader>ym", genghis.moveSelectionToNewFile, { desc = "Move selection to new file" })
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "work",
						path = "~/.config/vault",
					},
||||||| parent of 3a22224 (feat: big neovim update)
		ui = {
			border = "double",
		},
		performance = {
			rtp = {
				-- disable some rtp plugins
				disabled_plugins = {
					"gzip",
					"matchit",
					"matchparen",
					"netrwPlugin",
					"rplugin",
					"shada",
					"spellfile",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
=======
		config = function()
			require("overseer").setup()
			vim.keymap.set("n", "<leader>pp", require("overseer").toggle)
		end,
	},
	{
		"natecraddock/workspaces.nvim",
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
		event = "VeryLazy",
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
>>>>>>> 3a22224 (feat: big neovim update)
				},
<<<<<<< HEAD
			})

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
			{
				"phelipetls/jsonpath.nvim",
				ft = { "json" },
			},
		},
	},
	{
		"stevearc/overseer.nvim",
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
		event = "VeryLazy",
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
		cmd = "G",
		config = function()
			require("config_git")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("config_gitsigns")
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffViewOpen",
		config = function()
			require("diffview").setup()
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
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
		lazy = true,
		config = function()
			require("config_treesitter")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		config = function()
			require("config_telescope")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- "siawkz/nvim-cheatsh",
		},
	},
	{
		"Wansmer/treesj",
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
		event = "VeryLazy",
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
		"akinsho/toggleterm.nvim",
		lazy = true,
	},
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<leader>a", "<leader>a" },
			{ "<leader>xa", "<leader>xa" },
			{ "<leader>xx", "<leader>xx" },
			{ "<leader>1", "<leader>1" },
			{ "<leader>2", "<leader>2" },
			{ "<leader>3", "<leader>3" },
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
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"stevearc/dressing.nvim",
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
			"hrsh7th/cmp-cmdline",
			-- "PasiBergman/cmp-nuget",
			"https://codeberg.org/FelipeLema/cmp-async-path",
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
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
		event = "VeryLazy",
		build = ":MasonUpdate",
		config = function()
			require("config_lsp")
		end,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"ray-x/lsp_signature.nvim",
			{
				"someone-stole-my-name/yaml-companion.nvim",
				ft = { "yaml", "yml" },
			},
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
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
		},
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
		"ariel-frischer/bmessages.nvim",
		cmd = "Bmessages",
		opts = {},
	},
	{
		"nguyenvukhang/nvim-toggler",
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
			vim.cmd("hi WinBar ctermbg=none guibg=none")
			vim.cmd("hi WinBarNC ctermbg=none guibg=none")
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		enabled = false,
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
		enabled = false,
		keys = {
			{ "<leader>cr", "<leader>cr" },
		},
		config = function()
			require("config_telescope_cmd")
		end,
	},
	{
		"jay/local.nvim",
		event = "VeryLazy",
		dev = true,
		config = function()
			require("config_replace")
			require("config_clipboard")
			require("config_autoload")
			require("config_keymaps")
			require("config_codeautomation")
			require("config_note")
			require("config_worktrees")
			require("config_monorepo")
			-- require("config_buildtester")
			-- require("config_dotnet")
		end,
	},
}, {
	dev = {
		path = "~/repos/plugins/",
	},
	ui = {
		border = "double",
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
||||||| parent of 3a22224 (feat: big neovim update)
=======
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = "G",
		commit = "b068eaf",
		config = function()
			require("config_git")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("config_gitsigns")
		end,
	},
	-- {
	-- 	"sindrets/diffview.nvim",
	-- 	cmd = "DiffViewOpen",
	-- 	config = function()
	-- 		require("diffview").setup()
	-- 	end,
	-- },
	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
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
		lazy = true,
		config = function()
			require("config_treesitter")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		config = function()
			require("config_telescope")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- "siawkz/nvim-cheatsh",
		},
	},
	{
		"echasnovski/mini.splitjoin",
		keys = { { "<leader>jj", "<leader>jj" } },
		config = function()
			require("mini.splitjoin").setup({
				mappings = {
					toggle = "<leader>jj",
					split = "",
					join = "",
				},
			})
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "VeryLazy",
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
		"akinsho/toggleterm.nvim",
		lazy = true,
	},
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<leader>a", "<leader>a" },
			{ "<leader>xa", "<leader>xa" },
			{ "<leader>xx", "<leader>xx" },
			{ "<leader>1", "<leader>1" },
			{ "<leader>2", "<leader>2" },
			{ "<leader>3", "<leader>3" },
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
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"stevearc/dressing.nvim",
		enabled = true,
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
			"hrsh7th/cmp-cmdline",
			-- "PasiBergman/cmp-nuget",
			"https://codeberg.org/FelipeLema/cmp-async-path",
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
		},
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	--        enabled = false,
	-- 	lazy = true,
	-- 	config = function()
	-- 		require("config_copilot")
	-- 	end,
	-- },
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		build = ":MasonUpdate",
		config = function()
			require("config_lsp")
		end,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"ray-x/lsp_signature.nvim",
			{
				"someone-stole-my-name/yaml-companion.nvim",
				ft = { "yaml", "yml" },
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		enabled = false,
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
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
		},
	},
	{
		"mfussenegger/nvim-dap",
		enabled = true,
		keys = {
			{ "<leader><leader>s", "<leader><leader>s" },
			{ "<leader><leader>l", "<leader><leader>l" },
		},
		config = function()
			require("config_dap")
		end,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"ariel-frischer/bmessages.nvim",
		cmd = "Bmessages",
		opts = {},
	},
	{
		"nguyenvukhang/nvim-toggler",
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
			vim.cmd("hi WinBar ctermbg=none guibg=none")
			vim.cmd("hi WinBarNC ctermbg=none guibg=none")
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		enabled = false,
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
		"jay/local.nvim",
		event = "VeryLazy",
		dev = true,
		config = function()
			require("config_replace")
			require("config_clipboard")
			require("config_autoload")
			require("config_keymaps")
			require("config_codeautomation")
			require("config_note")
			require("config_worktrees")
			require("config_monorepo")
			require("config_buildtester")
			require("config_dotnet")
			require("config_other")
		end,
	},
}, {
	dev = {
		path = "~/repos/plugins/",
	},
	ui = {
		border = "double",
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
>>>>>>> 3a22224 (feat: big neovim update)
			},
		},
	},
})
