local cmp = require("cmp")
require("config_nvimcmp_conventional_commits")

local sourceMappings = {
	nvim_lsp = "LSP",
	buffer = "BUF",
	path = "PTH",
	async_path = "PTH",
	conventionalcommits = "COM",
	luasnip = "SNP",
	cmdline = "CMD",
	nuget = "NUG",
	["vim-dadbod-completion"] = "SQL",
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

local lspSpecs = {
	[1] = { name = "Text", priority = 10 },
	[2] = { name = "Method", priority = 100 },
	[3] = { name = "Function", priority = 100 },
	[4] = { name = "Constructor", priority = 10 },
	[5] = { name = "Field", priority = 100 },
	[6] = { name = "Variable", priority = 101 },
	[7] = { name = "Class", priority = 100 },
	[8] = { name = "Interface", priority = 100 },
	[9] = { name = "Module", priority = 80 },
	[10] = { name = "Property", priority = 100 },
	[11] = { name = "Unit", priority = 10 },
	[12] = { name = "Value", priority = 100 },
	[13] = { name = "Enum", priority = 10 },
	[14] = { name = "Keyword", priority = 10 },
	[15] = { name = "Snippet", priority = 200 },
	[16] = { name = "Color", priority = 5 },
	[17] = { name = "File", priority = 5 },
	[18] = { name = "Reference", priority = 10 },
	[19] = { name = "Folder", priority = 5 },
	[20] = { name = "EnumMember", priority = 100 },
	[21] = { name = "Constant", priority = 100 },
	[22] = { name = "Struct", priority = 100 },
	[23] = { name = "Event", priority = 100 },
	[24] = { name = "Operator", priority = 10 },
	[25] = { name = "TypeParameter", priority = 10 },
}

local function getLspScore(entry)
	return lspSpecs[entry:get_kind()].priority
end

local function customLspSorter(entry1, entry2)
	local score1 = getLspScore(entry1)
	local score2 = getLspScore(entry2)

	if score1 < score2 then
		return false
	elseif score1 > score2 then
		return true
	end

	return nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			-- require("luasnip").lsp_expand(args.body)
			vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
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
		-- format = function(entry, vim_item)
		-- 	local kind = vim_item.kind or "NotFound"
		-- 	local icon = iconMappings[string.lower(kind)] or ""
		--
		-- 	vim_item.kind = string.format("%s %s", icon, kind)
		--
		-- 	local maxLength = 40
		-- 	if string.len(vim_item.abbr) > maxLength then
		-- 		vim_item.abbr = string.sub(vim_item.abbr, 0, maxLength - 3) .. "..."
		-- 	end
		--
		-- 	vim_item.kind_hl_group = string.lower(tostring(kindMappings[string.lower(kind)] or ("@" .. kind)))
		-- 	vim_item.menu = string.format(" [%s]", sourceMappings[entry.source.name] or entry.source.name)
		-- 	vim_item.menu_hl_group = "CmpMenu"
		--
		-- 	return vim_item
		-- end,
		format = function(entry, vim_item)
			local kind = vim_item.kind or "NotFound"
			local icon = iconMappings[string.lower(kind)] or ""
			vim_item.kind = string.format("%s %s", icon, kind)

			local maxLength = 40
			if string.len(vim_item.abbr) > maxLength then
				vim_item.abbr = string.sub(vim_item.abbr, 0, maxLength - 3) .. "..."
			end

			local suffix = ""
			local ok, sourceName = pcall(entry.source.get_debug_name, entry.source)

			if ok then
				local potential = string.gsub(sourceName, "nvim_lsp:", "")
				if not string.match(suffix, ":") then
					suffix = " (" .. string.upper(string.sub(potential, 1, 3)) .. ")"
				end
			end

			vim_item.kind_hl_group = string.lower(tostring(kindMappings[string.lower(kind)] or ("@" .. kind)))
			vim_item.menu = string.format(" [%s]%s", sourceMappings[entry.source.name] or entry.source.name, suffix)
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
		-- ["<C-f>"] = function(option)
		-- 	print(vim.inspect(option()))
		-- 	---@field public reason? cmp.ContextReason
		-- 	---@field public config? cmp.ConfigSchema
		--
		--           k
		-- 	return function(fallback)
		-- 		fallback()
		-- 	end
		-- end,
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
		-- { name = "luasnip", group_index = 1 },
		{
			name = "nvim_lsp",
			group_index = 1,
			-- option = {
			-- 	test = function()
			-- 		return "abc"
			-- 	end,
			-- },
		},
		{ name = "copilot", group_index = 1 },
		{ name = "conventionalcommits", group_index = 1 },
		{
			name = "buffer",
			group_index = 2,
			option = {
				get_bufnrs = function()
					local bufs = {}
					-- local bufs = vim.tbl_filter(function(b)
					-- 	return vim.api.nvim_buf_is_valid(b)
					-- end, vim.api.nvim_list_bufs())

					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{ name = "async_path", group_index = 2 },
		-- { name = "path", group_index = 2 },
	},
	sorting = {
		comparators = {
			-- require("copilot_cmp.comparators").prioritize,
			-- customLspSorter,
			-- cmp.config.compare.kind,
			-- cmp_buffer.compare_word_distance,
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			customLspSorter,
			cmp.config.compare.recently_used,
			cmp.config.compare.score,
			cmp.config.compare.order,
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

cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion", group_index = 1 },
		{ name = "buffer", group_index = 1 },
	},
})

cmp.setup.filetype({ "csproj" }, {
	sources = {
		-- { name = "nuget", group_index = 1 },
		{ name = "buffer", group_index = 2 },
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
