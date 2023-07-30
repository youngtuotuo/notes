-- https://github.com/mhartington/formatter.nvim/tree/master/lua/formatter/filetypes
-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "--indent-type=spaces",
            "--indent-width=2",
            "--column-width=120",
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },
    c = {
      function()
        return {
          exe = "clang-format",
          args = { '--style="{BasedOnStyle: llvm, ColumnLimit: 120, IndentWidth: 2, AccessModifierOffset: -2}"' },
          stdin = true,
        }
      end,
    },
    cpp = {
      function()
        return {
          exe = "clang-format",
          args = { '--style="{BasedOnStyle: llvm, ColumnLimit: 120, IndentWidth: 2, AccessModifierOffset: -2}"' },
          stdin = true,
        }
      end,
    },
    python = {
      function()
        return { exe = "black", args = { "-l 120", "-q", "-" }, stdin = true }
      end,
    },
    go = {
      function()
        return { exe = "gofmt", stdin = true }
      end,
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})