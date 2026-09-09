local ls = require("luasnip")

local s  = ls.snippet
local i  = ls.insert_node
local t  = ls.text_node
local d  = ls.dynamic_node
local sn = ls.snippet_node

local M = {}

-- ---------------------------------------------------------------------------
-- CONDITIONS
-- ---------------------------------------------------------------------------

function M.in_math()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function M.not_in_math()
	return not M.in_math()
end


-- ---------------------------------------------------------------------------
-- REGEX
-- ---------------------------------------------------------------------------

-- Characters after which a shorthand may expand inside math mode.
--   "_ga"    -> "_\alpha "
--   "omega"  does not accidentally trigger "ga"

M.regex_math = "[%s%$%_%-%(%)%[%]%{%}%=%,%.;:]"


-- ---------------------------------------------------------------------------
-- NODE BUILDERS
-- ---------------------------------------------------------------------------

-- Used for snippets which consume the character before the trigger.

function M.expand_with_capture(replacement)
	return d(1, function(_, snip)
		return sn(nil, {
			t(snip.captures[1]),
			t(replacement .. " "),
		})
	end)
end


-- Enter an inline math environment from text mode.
--   ga<space> -> $\alpha<cursor>$ <exit>
function M.expand_text_math(replacement)
	return {
		t("$"),
		t(replacement),
		i(1),
		t("$ "),
		i(0),
	}
end


-- Return a copy of `nodes` with `str` prepended.
-- Does not modify the original node table.

function M.prepend(str, nodes)
	local result = { t(str) }

	for _, node in ipairs(nodes) do
		table.insert(result, node)
	end

	return result
end


-- ---------------------------------------------------------------------------
-- TABLE-DRIVEN SNIPPETS
-- ---------------------------------------------------------------------------

-- Generate snippets which only expand while already inside math mode.
-- Takes any number of tables: local snippets = u.math_snippets(greek, mathbb)

function M.math_snippets(...)
	local snippets = {}

	for _, tbl in ipairs({ ... }) do
		for trig, replacement in pairs(tbl) do
			table.insert(
				snippets,
				s({
						trig = "(" .. M.regex_math .. ")" .. vim.pesc(trig),
						regTrig = true,
						wordTrig = false,
						condition = M.in_math,
					},M.expand_with_capture(replacement))
			)
		end
	end

	return snippets
end


-- Generate snippets which enter inline math from text mode.
-- Takes any number of tables ga<space> -> $\alpha <cursor>$

function M.enter_math_snippets(...)
	local snippets = {}

	for _, tbl in ipairs({ ... }) do
		for trig, replacement in pairs(tbl) do
			table.insert(
				snippets,
				s(
					{
						trig = trig .. " ",
						wordTrig = true,
						condition = M.not_in_math,
					},
					M.expand_text_math(replacement)
				)
			)
		end
	end

	return snippets
end


-- ---------------------------------------------------------------------------
-- LIST UTILITIES
-- ---------------------------------------------------------------------------

-- Append every element of `source` to `target`.
-- for when a file contains both generated and special snippets

function M.extend(target, source)
	for _, value in ipairs(source) do
		table.insert(target, value)
	end

	return target
end


return M
