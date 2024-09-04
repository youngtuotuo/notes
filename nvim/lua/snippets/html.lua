require("luasnip.session.snippet_collection").clear_snippets = "tex"
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local snippets = {}
local utils = require("snippets.utils")

snippets = vim.tbl_extend("force", snippets, {
  s(
    { trig = "tag", snippetType = "autosnippet" },
    fmt(
      [[
      <{}>
      </{}>
      ]],
      {
        i(1),
        rep(1),
      }
    )
  ),
})
return snippets