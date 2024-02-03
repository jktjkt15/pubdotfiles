local cmp = require("cmp")

local sourceMappings = {
	nvim_lsp = "LSP",
	buffer = "BUF",
	path = "PTH",
	luasnip = "SNP",
	cmdline = "CMD",
}

local iconMappings = {
	property = "",
	["function"] = "",
	field = "",
	enum = "",
	keyword = "",
	snippet = "",
	text = "󰊄",
	variable = "",
	folder = "",
	-- keyword = "",
}

local kindMappings = {
	class = "@type",
	struct = "@type",
	enum = "@type.builtin",
	snippet = "@parameter",
	module = "@namespace",
	file = "@string",
	folder = "@method",
}

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert", --,noselect",
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},
	window = {
		completion = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuThumb,Search:None",
			scrolloff = 0,
			col_offset = 0,
			side_padding = 0,
			scrollbar = false,
		},
		documentation = {
			-- max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
			-- max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder",
			side_padding = 0,
		},
	},
	formatting = {
		-- expandable_indicator = true,
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			local kind = vim_item.kind or "NotFound"
			local icon = iconMappings[string.lower(kind)] or ""

			vim_item.kind = string.format("%s %s", icon, kind)

			local maxLength = 40
			if string.len(vim_item.abbr) > maxLength then
				vim_item.abbr = string.sub(vim_item.abbr, 0, maxLength - 3) .. "..."
			end

			vim_item.kind_hl_group = string.lower(tostring(kindMappings[string.lower(kind)] or ("@" .. kind)))
			vim_item.menu = string.format(" [%s]", sourceMappings[entry.source.name] or entry.source.name)
			vim_item.menu_hl_group = "CmpMenu"

			return vim_item
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.scroll_docs(-4),
		["<C-h>"] = cmp.mapping.scroll_docs(4),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- ["<c-k>"] = cmp.mapping.confirm({ select = false }),
		["<C-k>"] = cmp.mapping.complete(),
		-- ["<C-y>"] = cmp.mapping.complete(),
		["<Esc>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.mapping.abort()
				-- require("notify")(tostring(cmp.visible()))
			end
			fallback()
		end, { "i" }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }),
	},
	sources = {
		{ name = "luasnip", group_index = 1 },
		{ name = "nvim_lsp", group_index = 1 },
		{
			name = "buffer",
			group_index = 2,
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{ name = "path", group_index = 2 },
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.kind,
		},
	},
	experimental = {
		ghost_text = false,
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
		autocomplete = false, -- { "TextChanged" },
		keyword_length = 3,
	},
	mapping = {
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }), { "c" }),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }), { "c" }),
		["<Esc>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.abort()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-U><CR>", true, true, true), "", true)
			end
		end, { "c" }),
		["<C-k>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
		["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "c" }),
		-- ["<Tab>"] = { c = commandComplete },
	},
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
		autocomplete = false, -- { "TextChanged" },
		keyword_length = 2,
	},
	mapping = {
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior }), { "c" }),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior }), { "c" }),
		["<Esc>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.abort()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-U><CR>", true, true, true), "", true)
			end
		end, { "c" }),
		["<C-k>"] = cmp.mapping(cmp.mapping.complete(), { "c" }),
		["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "c" }),
		-- ["<Tab>"] = { c = commandComplete },
	},
	sources = {
		{ name = "cmdline" },
		{ name = "path" },
		{ name = "buffer" },
	},
})
