---@diagnostic disable: undefined-global
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local get_visual = function(args, parent)
	if (#parent.snippet.env.LS_SELECT_RAW > 0) then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end
local in_math = function()
	-- The `in_math` function requires the VimTeX plugin
	return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

return {}, {

	-- EXPONENTIATION
	--

	s({ trig = "([^%\\%s])E", regTrig = true, },
		fmta("<>^{<>} ", {
			f(function(_, snip) return snip.captures[1] end),
			d(1, get_visual), }),
		{ condition = in_math }
	),

	-- SUBSCRIPTS
	--

	s({ trig = "([^%\\%s])D", regTrig = true, },
		fmta("<>_{<>} ", {
			f(function(_, snip) return snip.captures[1] end),
			d(1, get_visual), }),
		{ condition = in_math }
	),



	-- LOGICAL SYMBOLS
	--

	s({ trig = "([^%\\%a])in", regTrig = true, wordTrig = false, dresc = "/in" },
		{ t(" \\in") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])fa", regTrig = true, wordTrig = false, dresc = "/forall" },
		{ t(" \\forall") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])te", regTrig = true, wordTrig = false, dresc = "/exists" },
		{ t(" \\exists") },
		{ condition = in_math }
	),

	s({ trig = "([^%\\%a])imp", regTrig = true, wordTrig = false, dresc = "/implies" },
		{ t(" \\implies") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])iff", regTrig = true, wordTrig = false, dresc = "/iff" },
		{ t(" \\iff") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])vert", regTrig = true, wordTrig = false, dresc = "/iff" },
		{ t("\\,\\vert\\,") },
		{ condition = in_math }
	),

	-- Subset and Supset
	s({ trig = "([^%\\%a])sub ", regTrig = true, wordTrig = false, dresc = "/subset" },
		{ t(" \\subset ") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])sube", regTrig = true, wordTrig = false, dresc = "/subseteq" },
		{ t(" \\subseteq ") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])sup ", regTrig = true, wordTrig = false, dresc = "/supset" },
		{ t(" \\supset ") },
		{ condition = in_math }
	),
	s({ trig = "([^%\\%a])supe", regTrig = true, wordTrig = false, dresc = "/supseteq" },
		{ t(" \\supseteq ") },
		{ condition = in_math }
	),



	-- PARENTHESIS
	--

	s({ trig = "sb ", wordTrig = false, regTrig = true },
		fmta("\\left( <> \\right)",
			{ d(1, get_visual) },
			{ condition = in_math })
	),
	s({ trig = "sq ", wordTrig = false, regTrig = true },
		fmta("\\left[ <> \\right]",
			{ d(1, get_visual) },
			{ condition = in_math })
	),
	s({ trig = "sc ", wordTrig = false, regTrig = true },
		fmta("\\left\\{ <> \\right\\}",
			{ d(1, get_visual) },
			{ condition = in_math })
	),
	s({ trig = "sv ", wordTrig = false, regTrig = true },
		fmta("\\left| <> \\right|",
			{ d(1, get_visual) },
			{ condition = in_math })
	),
}
