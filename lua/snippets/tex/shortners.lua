local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

local u  = require("snippets.tex.utils")

return {}, {



-- vector for: x_1,\dots,x_n
  s(
    {
      trig = "vect ",
      condition = u.in_math,
    },
    {
      i(1, "x"), --variable
      t("_1, \\dots, "),
      f(function(args)
        return args[1][1]
      end, {1}),
      t("_"),
      i(2, "n"), -- index
    }
  ),

}
