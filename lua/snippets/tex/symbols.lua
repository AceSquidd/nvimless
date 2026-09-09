local ls = require("luasnip")
local s  = ls.snippet
local u  = require("snippets.tex.utils")



-- autosnippets of symboles used in math mode.

-- trigger tables

local logic = {
	iff     = "\\iff",
	imp     = "\\implies",
    ipd     = "\\impliedby",

	land    = "\\land",
	lor     = "\\lor",

	-- sets
	["in"]  = "\\in",
	["ss "] = "\\subset",
	sse     = "\\subseteq",
	ssn     = "\\subsetneq",
	cup     = "\\cup",
	dcup    = "\\sqcup",
	cap     = "\\cap",
	dcap    = "\\sqcap",

	empty   = "\\emptyset",
	ify     = "\\infty",
}


-- implementation

local snippets = u.math_snippets(logic)

return {}, snippets
