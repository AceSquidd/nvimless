local ls   = require("luasnip")
local s    = ls.snippet
local t    = ls.text_node
local i    = ls.insert_node
local f    = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local u    = require("snippets.tex.utils")

return {}, {



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
		{ trig = "smalluniprop", condition = not u.in_math },
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
