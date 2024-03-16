return {
  "lewis6991/gitsigns.nvim",
  cond = vim.fn.finddir(".git", vim.fn.getcwd() .. ";") ~= "",
  event = { "BufRead" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "-" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = false,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = _G.border,
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = { enable = false },
  },
  config = function(_, opts)
    local gs = require("gitsigns")
    gs.setup(opts)

    local next_hunk = function()
      gs.next_hunk()
      HLFound(0.4)
    end
    local prev_hunk = function()
      gs.prev_hunk()
      HLFound(0.4)
    end
    local stage_hunk = require("gitsigns").stage_hunk
    local reset_hunk = require("gitsigns").reset_hunk
    local preview_hunk = require("gitsigns").preview_hunk
    local blame_line = require("gitsigns").blame_line
    local toggle_signs = require("gitsigns").toggle_signs

    local ts_obj_status, ts_rep = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if ts_obj_status then
      next_hunk, prev_hunk = ts_rep.make_repeatable_move_pair(next_hunk, prev_hunk)
    end

    vim.keymap.set("n", "]h", next_hunk, { desc = "Gitsigns next hunk" })
    vim.keymap.set("n", "[h", prev_hunk, { desc = "Gitsigns previous hunk" })
    vim.keymap.set("n", "<space>hs", stage_hunk, { desc = "Gitsigns stage hunk" })
    vim.keymap.set("n", "<space>hr", reset_hunk, { desc = "Gitsigns reset hunk" })
    vim.keymap.set("n", "<space>hp", preview_hunk, { desc = "Gitsigns preview hunk" })
    vim.keymap.set("n", "<space>hb", blame_line, { desc = "Gitsigns line blame" })
    vim.keymap.set("n", "<leader>g", toggle_signs, { desc = "Gitsigns toggle sign" })
  end,
}
