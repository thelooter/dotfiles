local ls = require "luasnip"
local snippet = ls.snippet
local text_node = ls.text_node
local insert_node = ls.insert_node

local fmt_node = require("luasnip.extras.fmt").fmt
local repeat_node = require("luasnip.extras").rep
local lambda_node = require("luasnip.extras").lambda
-- local c = ls.choice_node
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node

local snippets = {
  ls.parser.parse_snippet("lm", "local M = {}\n\nfunction M.setup()\n  $1 \nend\n\nreturn M"),
  -- s("lm", { t { "local M = {}", "", "function M.setup()", "" }, i(1, ""), t { "", "end", "", "return M" } }),
  snippet("todo", text_node "print('TODO')"),

  snippet("localreq", fmt_node("local {} = require('{}')", {
    insert_node(1, "default"),
    repeat_node(1)
  })),

  snippet("preq",
    fmt_node('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
      lambda_node(lambda_node._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
      insert_node(1, "module")
    })
  ),

  ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
}

return snippets
