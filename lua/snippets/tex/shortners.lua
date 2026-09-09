local ls   = require("luasnip")
local s    = ls.snippet
local t    = ls.text_node
local i    = ls.insert_node
local f    = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local u    = require("snippets.tex.utils")



local function make_subscript(_, snip)
	local base = snip.captures[1]
	local sub = snip.captures[2]

	if #sub == 1 then
		return base .. "_" .. sub
	end

	return base .. "_{" .. sub .. "}"
end

local subscript = s(
	{
		trig = "([a-zA-Z])([0-9]+)",
		regTrig = true,
		wordTrig = false,
		snippetType = "autosnippet",
		condition = u.in_math,
	},
	f(make_subscript)
)


local snippets = {
	subscript,
	-- vector for: x_1,\dots,x_n
	s(
		{
			trig = "vect ", condition = u.in_math,
		},
		{
			i(1, "x"), --variable
			t("_1, \\dots, "),
			f(function(args)
				return args[1][1]
			end, { 1 }),
			t("_"),
			i(2, "n"), -- index
		}
	),



	-- tikz universal prop small diagram
	s(
		{ trig = "smalluniprop", condition = u.not_in_math },
		fmta(
			[[
\begin{tikzcd}
  <> \arrow[r, "<>"] \arrow[dr, swap, "<>"] & <> \arrow[d, dashed, "<>"] \\
  & <>
\end{tikzcd}
]],
			{
				i(1, "A"), -- top left
				i(2, "f"), -- top arrow
				i(3, "h"), -- diagonal arrow
				i(4, "B"), -- top right
				i(5, "!"), -- dashed arrow
				i(6, "C"), -- bottom
			}
		)
	),

	-- tikz universal prop large diagram
	s(
		{ trig = "uniprop ", condition = not u.in_math },
		fmta(
			[[
\[\begin{tikzcd}
  <> \arrow[r, "<>"] \arrow[d, swap, "<>"] & <>  \\
  <> \arrow[ur, dashed, swap,  "\exists! <>"]
\end{tikzcd}\]
]],
			{
				i(1, "A"),
				i(2, "f"),
				i(3, "g"),
				i(4, "B"),
				i(5, "C"),
				i(6, "h"),
			}
		)
	)

}

-- parenthesis

local delimiters = {
	["sb "] = { "\\left(", "\\right)" },
	["sq "] = { "\\left[", "\\right]" },
	["sc "] = { "\\left\\{", "\\right\\}" },
}

for trig, delim in pairs(delimiters) do
	table.insert(
		snippets,
		s(
			{
				trig = trig,
				wordTrig = false,
				snippetType = "autosnippet",
				condition = u.in_math,
			},
			{
				t(delim[1]),
				i(1),
				t(delim[2]),
				i(0),
			}
		)
	)
end

-- subscripts for \

table.insert(
	snippets,
	s(
		{
			trig = "_\\",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = u.in_math,
		},
		{
			t("_{\\"),
			i(1),
			t("}"),
			i(0),
		}
	)
)

return {}, snippets
