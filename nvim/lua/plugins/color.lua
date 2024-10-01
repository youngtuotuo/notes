local has_256_colors = (string.find(vim.api.nvim_list_uis()[1].term_name, "xterm%-256color") ~= nil)
  or (string.find(vim.api.nvim_list_uis()[1].term_name, "tmux%-256color") ~= nil)
  or (string.find(vim.api.nvim_list_uis()[1].term_name, "screen%-256color") ~= nil)
  or (string.find(vim.api.nvim_list_uis()[1].term_name, "alacritty") ~= nil)
  or (vim.fn.has("win32") == 1)
return {
  {
    "norcalli/nvim-colorizer.lua",
    lazy = not has_256_colors,
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup()
    end,
  },
  {
    "catppuccin/nvim",
    lazy = not has_256_colors,
    opts = {
      transparent_background = true,
      show_end_of_buffer = true,
      highlight_overrides = {
        mocha = function(mocha)
          return {
            StatusLine = { bg = "none" },
            StatusLineNC = { bg = "none" },
          }
        end,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colo("catppuccin")
    end,
  },
  {
    "jacoborus/tender.vim",
    lazy = has_256_colors,
    config = function()
      vim.cmd.color("tender")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "branch", "diff", "diagnostics", "filename" },
        lualine_x = { "encoding", "fileformat", "filetype", "progress", "location" },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "branch", "diff", "diagnostics", "filename" },
        lualine_x = { "encoding", "fileformat", "filetype", "progress", "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
