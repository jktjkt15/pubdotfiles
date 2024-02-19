require("markview").setup({
	-- style = "label",
	modes = { "n" },
	block_quotes = {
		enable = false,
	},
	code_blocks = {
		enable = true,
		style = "simple",
		position = "overlay",

		-- hl = "irntirn",

		min_width = 70,
		pad_char = " ",
		pad_amount = 2,

		language_names = nil,
		name_hl = nil,
		language_direction = "right",

		sign = false,
		sign_hl = nil,
	},
	headings = {
		enable = true,
		-- shift_width = vim.o.shiftwidth,
		-- hl = "rainbow",
		style = "label",

		heading_1 = {
			style = "label",
			padding_left = "    ",
			padding_left_hl = "lualine_a_normal",
			padding_right = "    ",
			padding_right_hl = "lualine_a_normal",
			shift_char = " ",
			hl = "lualine_a_normal",
		},
		heading_2 = {
			style = "label",
			padding_left = "    ",
			padding_left_hl = "lualine_a_visual",
			padding_right = "    ",
			padding_right_hl = "lualine_a_visual",
			shift_char = " ",
			hl = "lualine_a_visual",
		},
		heading_3 = {
			style = "label",
			padding_left = "    ",
			padding_left_hl = "lualine_a_insert",
			padding_right = "    ",
			padding_right_hl = "lualine_a_insert",
			shift_char = " ",
			shift_char_hl = "lualine_a_insert",
			hl = "lualine_a_insert",
		},

		-- heading_1 = {
		-- 	style = "simple",
		-- 	hl = "col_1",
		-- },
		-- heading_2 = {
		-- 	style = "label",
		-- 	hl = "col_2",
		--
		-- 	corner_left = " ",
		-- 	padding_left = nil,
		--
		-- 	icon = "⑄ ",
		--
		-- 	padding_right = " ",
		-- 	padding_right_hl = "col_2_fg",
		--
		-- 	corner_right = "█▓▒░",
		--
		-- 	sign = "▶ ",
		-- 	sign_hl = "col_2_fg",
		-- },
		-- heading_3 = {
		-- 	style = "icon",
		-- 	hl = "col_3",
		--
		-- 	shift_char = "─",
		-- 	icon = "┤ ",
		--
		-- 	text = "Heading lvl. 3",
		--
		-- 	sign = "▷ ",
		-- 	sign_hl = "col_2_fg",
		-- },
		--
		-- --- Similar tables for the other headings
		-- -- heading_4 = { ... },
		-- -- heading_5 = { ... },
		-- -- heading_6 = { ... },
		--
		-- -- For headings made with = or -
		-- setext_1 = {
		-- 	style = "simple",
		-- 	hl = "col_1",
		-- },
		-- setext_2 = {
		-- 	style = "github",
		--
		-- 	hl = "col_2",
		-- 	icon = " 🔗  ",
		-- 	line = "─",
		-- },
	},
})
