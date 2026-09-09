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
	bc = "\\mathbb{C}",
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

local snippets = u.math_snippets(
	greek,
	mathbb,
	mathcal,
	groups
)

-- snippets with access from outside math
u.extend(
	snippets,
	u.enter_math_snippets(
		greek,
		mathcal
	)
)

return {}, snippets
