local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

local u = require("snippets.tex.utils")

local snippets = {}

local function add(trig, expansion, condition)
	table.insert(
		snippets,
		s(
			{
				trig = trig,
				wordTrig = true,
				snippetType = "autosnippet",
				condition = condition,
			},
			t(expansion)
		)
	)
end

-- ---------------------------------------------------------------------------
-- SUCH THAT
-- ---------------------------------------------------------------------------

-- Text: x st y -> x such that y
add(
	"st ",
	"such that ",
	u.not_in_math
)

-- Inline math: $x st y$ -> $x$ such that $y$
add(
	" st ",
	"$ such that $",
	u.in_inline_math
)

-- Display math:$$ A st B $$ -> $$ A \text{ s.t. } B $$
add(
	" st ",
	" \\text{ s.t. } ",
	u.in_display_math
)


-- ---------------------------------------------------------------------------
-- FOR
-- ---------------------------------------------------------------------------

-- Inline math: $x > 0 for x \in A$ -> $x > 0$ for $x \in A$
add(
	" for ",
	"$ for $",
	u.in_inline_math
)

-- Display math: $$ x > 0 for x \in A $$ -> $$ x > 0 \quad \text{ for } x \in A $$
add(
	" for ",
	" \\quad \\text{ for } ",
	u.in_display_math
)

return {}, snippets
