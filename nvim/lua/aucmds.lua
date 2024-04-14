local group = vim.api.nvim_create_augroup(_G.auG, { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Yank Short Indicator",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.c", "*.cpp" },
  group = group,
  callback = function()
    -- vim.cmd([[compiler gcc]])
    vim.opt_local.cinoptions = [[=0]]
    -- vim.opt_local.makeprg = vim.fn.has("win32") == 1 and [[build.bat]] or [[./build.sh]]
    vim.opt_local.define = [[^\s*#\s*define]]
  end,
  desc = "aucmd for c/cpp",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  group = group,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    -- vim.opt_local.makeprg = [[lua %]]
    -- vim.opt_local.errorformat=[[lua:[string %.+]:%l+:%m,lua:%f:%l:%m,lua:%m,%s+ [string %.+]:%l+:%m,%f:%l:%m]]
  end,
  desc = "aucmd for lua",
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.py" },
--   group = group,
--   callback = function()
--     -- :h errorformat
--     vim.opt_local.errorformat = [[%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m]]
--     vim.opt_local.makeprg = [[python3 %]]
--   end,
--   desc = "aucmd for python",
-- })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "Makefile" },
  group = group,
  callback = function()
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 0
    vim.opt_local.expandtab = false
  end,
  desc = "Change indent to tab for Makefile",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.html", "*.yaml" },
  group = group,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "Change indent level to 2 for json, html, yaml",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  callback = function()
    vim.opt.formatoptions = "jql"
  end,
  desc = "All buffer need formatoptions = jql",
})
