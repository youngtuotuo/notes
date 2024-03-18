return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  keys = function()
    local format = function()
      require("conform").format()
    end
    return {
      { "<leader>f", format, mode = { "n", "v" }, desc = "Format buffer" },
    }
  end,
  opts = {
    async = true,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "gofumpt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      zig = { "zigfmt" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      json = { "jq" },
    },
    formatters = {
      stylua = {
        prepend_args = {
          "--indent-type=spaces",
          "--indent-width=2",
          "--column-width=120",
        },
      },
      clang_format = {
        prepend_args = {
          "-style={BasedOnStyle: llvm, ColumnLimit: 120, IndentWidth: 4, AccessModifierOffset: -4, IndentCaseLabels: true, AlignOperands: AlignAfterOperator, PointerAlignment: Right}",
        },
      },
      ruff_fmt = {
        prepend_args = {
          "--line-length=120"
        }
      }
    },
    format_on_save = nil,
    format_after_save = nil,
  },
}
