local ls = require("luasnip")
local s  = ls.snippet
local sn = ls.snippet_node
local d  = ls.dynamic_node
local u  = require("snippets.tex.utils")


-- autosnippets of the type ga -> \alpha or cB -> \mathcal{B}
-- simple shorthands with no addition input and pnly a "s" nodes

-- trigger tables

-- GREEKS

local greek   = {
	ga = "\\alpha",
	gb = "\\beta",
	gc = "\\gamma",
	gd = "\\delta",
	ge = "\\epsilon",
	gt = "\\theta",

	gk = "\\kappa",
	gl = "\\lambda",
	gm = "\\mu",
	gn = "\\nu",
	gr = "\\rho",
	gs = "\\sigma",
	gq = "\\chi",
	gy = "\\psi",
	go = "\\omega",

	gf = "\\phi",
	gp = "\\varphi",
	gw = "\\psi",
	pi = "\\pi",

	gO = "\\Omega",
	gP = "\\Varphi",
	gW = "\\Psi",

}

-- BLACKBOARD

local mathbb  = {
	bn = "\\mathbb{N}",
	bz = "\\mathbb{Z}",
	bq = "\\mathbb{Q}",
	br = "\\mathbb{R}",
}

-- MATHCAL

local mathcal = {
	cA = "\\mathcal{A}",
	cB = "\\mathcal{B}",
	cC = "\\mathcal{C}",
	cF = "\\mathcal{F}",
	cT = "\\mathcal{T}",
	cL = "\\mathcal{L}",
	cO = "\\mathcal{O}",
	cM = "\\mathcal{M}",
}

-- GROUPS
local groups = {
	Sn = "S^n",
}


-- implementation

local snippets = {}

local function add_inside(tbl)
	for trig, cmd in pairs(tbl) do
		table.insert(snippets,
			s(
				{
					trig = "(" .. u.regex_math .. ")" .. trig,
					regTrig = true,
					wordTrig = false,
					condition = u.in_math,
				},
				u.expand_with_capture(cmd)
			)
		)
	end
end

add_inside(greek)
add_inside(mathbb)
add_inside(mathcal)
add_inside(groups)

-- from here, these are implementations of above symbols into text mode.
-- "let ga be a constant" will expand into "let $ \alpha $ be a constant".

local function add_enter(tbl)
	for trig, cmd in pairs(tbl) do
		table.insert(snippets,
			s(
				{
					trig = trig .. " ",
					wordTrig = true,
					condition = not u.in_math,
				},
				u.expand_text_math(cmd)
			)
		)
	end
end

add_enter(greek)
-- no need for mathbb
add_enter(mathcal)

table.insert(snippets,
	s(
		{
			trig = " m(.)%s",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function() return not u.in_math() end,
		},
		d(1, function(args, snip)
			return sn(nil,u.prepend(" ", u.expand_text_math(snip.captures[1])))
		end)

	)
)

return {}, snippets
