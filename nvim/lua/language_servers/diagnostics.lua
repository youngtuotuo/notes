local diag_config = {
  virtual_text = true,
  signs = false,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  float = {
    header = "",
    prefix = function()
      return ""
    end,
    focusable = true,
    title = " σ`∀´)σ ",
    border = _G.border,
    max_width = 40,
  },
}

vim.diagnostic.config(diag_config)
