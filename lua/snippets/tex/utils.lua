local ls = require("luasnip")
local i  = ls.insert_node
local t  = ls.text_node
local d  = ls.dynamic_node
local sn = ls.snippet_node

-- main return table
local M = {}

-- -- -- -- -- -- -- -- -- -- -- -- CONDITIONS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

-- in_math condition
function M.in_math()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end


-- -- -- -- -- -- -- -- -- -- -- -- REGEXS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

M.regex_math = "[%s%$%_%-%(%)%[%]%{%}%=%,%.;:]"


-- -- -- -- -- -- -- -- -- -- -- -- FUNCTIONS -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function M.expand_with_capture(replacement)
  return d(1, function(_, snip)
    return sn(nil, {
      t(snip.captures[1]),
      t(replacement .. " "),
    })
  end)
end


function M.expand_text_math(replacement)
  return {
        t("$"),
        t(replacement .. " "),
        i(1),        -- stay in math
        t("$ "),
        i(0),        -- outside math
  }
end

function M.prepend(str, nodes)
	local fin = nodes
	table.insert(fin, 1, t(str))
	return fin
end


return M
