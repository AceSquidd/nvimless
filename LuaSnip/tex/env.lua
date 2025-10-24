---@diagnostic disable: undefined-global

local line_begin = require("luasnip.extras.expand_conditions").line_begin
local get_visual = function(args, parent)
	if (#parent.snippet.env.LS_SELECT_RAW > 0) then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end




return {}, {

	-- MATH $$
	s({ trig = "([^%a])mm", wordTrig = false, regTrig = true },
		fmta(
			"<>$<>$",
			{
				f(function(_, snip) return snip.captures[1] end),
				d(1, get_visual),
			}
		)
	),
	s({ trig = "mm" },
		fmta(
			[[
            $$ <> $$
            ]],
			-- insert nodes in angel brackets
			{ i(1) }
		),
		{ condtion = line_begin }
	),
	s({ trig = "DEF" },
		fmta(
			[[
			\begin{defi}[<>]
            	
			\end{defi}
            ]],
			-- insert nodes in angel brackets
			{ i(1) }
		),
		{ condtion = line_begin }
	),
}
