local g = require("tuo.global")
require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = g.trans, -- Enable this to disable setting the background color
  terminal_colors = false, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = false },
    keywords = { italic = false },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    local float_bg = "none"
    local status_bg = colors.bg
    if g.trans then
      status_bg = "none"
    end
    highlights.NormalFloat = { fg = colors.fg, bg = float_bg }
    highlights.FloatBorder = { fg = colors.border_highlight, bg = float_bg }
    highlights.LspReferenceWrite = { underline = false, bg = colors.bg_highlight, standout = true }
    highlights.StatusLine = { fg = colors.fg, bg = status_bg }
    highlights.StatusLineNC = { fg = colors.fg_dark, bg = status_bg }
    highlights.TelescopeNormal = {
      bg = float_bg,
      fg = colors.fg,
    }
    highlights.TelescopePromptNormal = { bg = float_bg }
    highlights["@text.literal.markdown_inline"] = { bg = "none" }
    highlights.Todo = { fg = "#10B981", bg = "none" }
    highlights.SignColumnSB = { bg = "none" }
    highlights.IblScope = { fg = "#cccccc" }
    highlights.EoLSpace = { bg = "#884455" }
    -- all link below
    highlights.NormalSB = { link = "Normal" }
    highlights.Pmenu = { link = "FloatBorder" }
    highlights.SagaBorder = { link = "FloatBorder" }
    highlights.DiagnosticShowBorder = { link = "FloatBorder" }
    highlights.CmpCompletionBorder = { link = "FloatBorder" }
    highlights.CmpDocumentationBorder = { link = "FloatBorder" }
    highlights.LspInfoBorder = { link = "FloatBorder" }
    highlights.TelescopeBorder = { link = "FloatBorder" }
    highlights.FloatTitle = { link = "Search" }
    highlights.Sagatitle = { link = "FloatBorder" }
    highlights.LazyNormal = { link = "NormalFloat" }
    highlights.MasonNmeormal = { link = "NormalFloat" }
    highlights.SagaNormal = { link = "NormalFloat" }
    highlights.RenameNormal = { link = "NormalFloat" }
    highlights.LspReferenceText = { link = "LspReferenceWrite" }
    highlights.LspReferenceRead = { link = "LspReferenceWrite" }
    highlights.VertSplit = { link = "SignColumn" }
    highlights.IdlIndent = { link = "SignColumn" }
    highlights.LspInlayHint = { link = "SignColumn" }
    highlights.WinSeparator = { link = "VertSplit" }
    highlights.luaParenError = { link = "Normal" }
    highlights.TelescopeBorder = { link = "FloatBorder" }
    highlights.TelescopePromptBorder = { link="FloatBorder" }
    highlights.TelescopePromptTitle = { link = "Search" }
    highlights.TelescopePreviewTitle = { link = "Search" }
    highlights.TelescopeResultsTitle = { link = "Search" }
  end,
})

vim.cmd([[colorscheme tokyonight]])
