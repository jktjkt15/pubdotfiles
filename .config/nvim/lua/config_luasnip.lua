local ls = require("luasnip")

ls.setup({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.choice_active(1) then
		ls.change_choice(1)
	end
end, { silent = true })

local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local c = ls.choice_node
local t = ls.text_node

ls.cleanup()
ls.add_snippets(nil, {
	all = {
		-- s("test123", fmt("local {} = {}", { i(1, "default"), rep(1) })),
	},
	lua = {
		s("req", fmt([[local {} = require("{}")]], { rep(1), i(1) })),
	},
	cs = {
		s(
			"ctor",
			fmt(
				[[
            public {}()
            {{
                {}
            }}
            ]],
				{ i(1, "Name"), i(0) }
			)
		),
		s("cw", fmt([[Console.WriteLine($"{}");]], { c(1, { t("{}"), t("") }) })),
		s("cwe", fmt([[Console.WriteLine($"{} = {{{}}}");]], { rep(1), i(1) })),
		s("sis", fmt([[$"{}"{}]], { i(1), i(0) })),
		s("cal", fmt([[yield return AddLine($"{}", indentLevel{});]], { i(1), c(2, { t(""), t(" + 1") }) })),
		s("s??", fmt([[{} ?? throw new ArgumentNullException(nameof({}));]], { rep(1), i(1) })),
		s(
			"fore",
			fmt(
				[[foreach (var {} in {}) 
{{
    {}
}}]],
				{ i(2), i(1), i(0) }
			)
		),
		s(
			"prop",
			fmt(
				[[{} {} {} {{ get; {} }} ]],
				{ c(1, { t("public"), t("private") }), i(2), i(3), c(4, { t("set;"), t("") }) }
			)
		),
	},
})
