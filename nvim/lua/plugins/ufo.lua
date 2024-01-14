return {
  "kevinhwang91/nvim-ufo",
  event = { "BufRead" },
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
    provider_selector = function(_, _, _)
      return { "indent" }
    end,
  },
  config = function(_, opts)
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- stylua: ignore
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
      end, { desc = "Peek fold" }
    )

    require("ufo").setup(opts)
  end,
}