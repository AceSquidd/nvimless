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

	-- GREEK LETTERS

      s({trig = "ga", dresc = "alpha"},
            {t("\\alpha")},
            {condition = in_mathzone}
      ),
      s({trig = "gb", dresc = "beta"},
            {t("\\beta")},
            {condition = in_mathzone}
      ),
       s({trig = "gc", dresc = "gamma"},
            {t("\\gamma")},
            {condition = in_mathzone}
      ),
	  s({trig = "(^[_])gc", dresc = "gamma"},
            {t("\\gamma")},
            {condition = in_mathzone}
      ),
      s({trig = "gp", dresc = "phi"},
            {t("\\phi")},
            {condition = in_mathzone}
      ),

	-- CALLIGRAFIC LETTERS

      s({trig = "cT", dresc = "T for topology"},
            {t("\\mathcal{T}")},
            {condition = in_mathzone}
      ),
      s({trig = "cB", refTrig = true, dresc = "B for topologic basis"},
            {t("\\mathcal{B}")},
            {condition = in_mathzone}
      ),

	-- DOMAINS

	s({ trig = "bn"},
		{ t("\\mathbb{N}") },
		{ condition = in_mathzone }
	),
	s({ trig = "bz"},
		{ t("\\mathbb{Z}") },
		{ condition = in_mathzone }
	),
	s({ trig = "br"},
		{ t("\\mathbb{R}") },
		{ condition = in_mathzone }
	),
	s({ trig = "bc"},
		{ t("\\mathbb{C}") },
		{ condition = in_mathzone }
	),

   -- Complex Subdomains

	s({ trig = "bC "},
		{ t("\\mathbb{C}^*") },
		{ condition = in_mathzone }
	),
	s({ trig = "bC-"},
		{ t("\\mathbb{C}_-") },
		{ condition = in_mathzone }
	),

   -- Groups (TO DO)

	s({ trig = "znz "},
		{ t("\\mathbb{Z}/n\\mathbb{Z}") },
		{ condition = in_mathzone }
	),
	s({ trig = "zpz "},
		{ t("\\mathbb{Z}/p\\mathbb{Z}") },
		{ condition = in_mathzone }
	),
}
