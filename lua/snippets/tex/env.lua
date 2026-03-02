local ls       = require("luasnip")
local s        = ls.snippet
local i        = ls.insert_node
local t        = ls.text_node
local u        = require("snippets.tex.utils")

local autosnippets = {}

table.insert { autosnippets,
	s(
		{
			trig = "mm",
			wordTrig = true,
			condition = function() return not u.in_math() end,
		},
		{
			t("$"),
			i(1),
			t("$ "),
			i(0),
		}
	),
	s(
		{
			trig = "MM",
			wordTrig = true,
			condition = function() return not u.in_math() end,
		},
		{
			t("$$"),
			i(1),
			t("$$"),
			i(0),
		}
	)

}

return {}, autosnippets
