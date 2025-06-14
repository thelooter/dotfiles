local ls            = require "luasnip"
local snippet       = ls.snippet
local function_node = ls.function_node
local text_node     = ls.text_node
local choice_node   = ls.choice_node
local snippet_node  = ls.snippet_node
local dynamic_node  = ls.dynamic_node
local insert_node   = ls.insert_node

local partial_node  = require("luasnip.extras").partial
local fmt_node      = require("luasnip.extras.fmt").fmt
local repeat_node   = require("luasnip.extras").rep

local function bash(_, snip)
  local file = io.open(snip.trigger, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

local snippets = {
  snippet({ trig = "ymd", name = "Current date", dscr = "Insert the current date" }, {
    partial_node(os.date, "%Y-%m-%d"),
  }),

  snippet({ trig = "pwd" }, { function_node(bash, {}) }),

  snippet("choice", {
    choice_node(1, {
      text_node "choice 1",
      text_node "choice 2",
      text_node "choice 3"
    })
  }),

  snippet("dt", function_node(function()
    return os.date "%D - %H:%M"
  end)),

  snippet("sn", snippet_node(1, {
    text_node { "Select a Choice: " },
    choice_node(1, {
      text_node "choice 1",
      text_node "choice 2",
      text_node "choice 3"
    })
  })),

  snippet("dn", {
    text_node "from: ",
    insert_node(1),
    text_node { "", "to: " },
    dynamic_node(2, function(args)
      return snippet_node(nil, {
        insert_node(1, args[1]),
      })
    end, {
      1,
    })
  }),

  snippet("fmt2", fmt_node(
    [[
  foo({1}, {3}) {{
    return {2} * {4}
  }}
    ]],
    {
      insert_node(1, "x"),
      repeat_node(1),
      insert_node(2, "y"),
      repeat_node(2)
    }
  )),

  snippet("yy", partial_node(os.date, "%Y"))
}


return snippets
