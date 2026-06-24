-- require("ibl").setup({
-- 	indent = { highlight = "Comment" },
-- 	whitespace = {
-- 		remove_blankline_trail = false,
-- 	},
-- 	scope = { enabled = false },
-- })

require("blink.indent").setup({
	blocked = {
		-- default: 'terminal', 'quickfix', 'nofile', 'prompt'
		buftypes = { include_defaults = true },
		-- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
		filetypes = { include_defaults = true },
	},
	mappings = {
		-- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
		border = "both",
		-- set to '' to disable
		-- textobjects (e.g. `y2ii` to yank current and outer scope)
		object_scope = "",
		object_scope_with_border = "",
		-- motions
		goto_top = "",
		goto_bottom = "",
	},
	static = {
		enabled = true,
		char = "▎",
		whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
		priority = 1,
		-- specify multiple highlights here for rainbow-style indent guides
		-- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
		highlights = { "Comment" },
	},
	scope = {
		enabled = false,
		char = "▎",
		priority = 1000,
		-- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
		-- highlights = { 'BlinkIndentScope' },
		-- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
		highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
		-- enable to show underlines on the line above the current scope
		underline = {
			enabled = false,
			-- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
			highlights = { "BlinkIndentOrangeUnderline", "BlinkIndentVioletUnderline", "BlinkIndentBlueUnderline" },
		},
	},
})
