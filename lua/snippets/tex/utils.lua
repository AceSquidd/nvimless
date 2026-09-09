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


-- differentiate between mathzones
--   Since VimTex is not precise enough, we brute force it. Detects:
--   $ ... $ or $$ ... $$ or plain text
-- Escaped dollar signs (\$) and comments are ignored.
function M.math_context()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local col = cursor[2]

	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

	-- Only inspect text before the cursor on the current line.
	if #lines > 0 then
		lines[#lines] = lines[#lines]:sub(1, col)
	end

	local mode = "text"

	for _, line in ipairs(lines) do
		local j = 1

		while j <= #line do
			local char = line:sub(j, j)

			-- Count backslashes immediately before this character.
			local slashes = 0
			local k = j - 1

			while k >= 1 and line:sub(k, k) == "\\" do
				slashes = slashes + 1
				k = k - 1
			end

			local escaped = slashes % 2 == 1

			-- Ignore the rest of a LaTeX comment.
			if char == "%" and not escaped then
				break
			end

			if char == "$" and not escaped then
				-- $$ delimiter
				if line:sub(j, j + 1) == "$$" then
					if mode == "display" then
						mode = "text"
					elseif mode == "text" then
						mode = "display"
					end

					j = j + 2

				-- $ delimiter
				else
					if mode == "inline" then
						mode = "text"
					elseif mode == "text" then
						mode = "inline"
					end

					j = j + 1
				end
			else
				j = j + 1
			end
		end
	end

	return mode
end


function M.in_inline_math()
	return M.math_context() == "inline"
end


function M.in_display_math()
	return M.math_context() == "display"
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
