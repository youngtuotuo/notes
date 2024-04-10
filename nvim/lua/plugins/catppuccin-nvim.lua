return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    transparent_background = true,
    show_end_of_buffer = true,
    term_colors = false,
    dim_inactive = { enabled = false },
    no_italic = true,
    no_bold = true,
    no_underline = true,
    default_integrations = false
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colo [[catppuccin]]
    _G.colorset()
  end
}
