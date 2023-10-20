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
    local float_bg = colors.fg_gutter
    local status_bg = colors.bg
    local tele_bg = colors.bg_popup
    if g.trans then
      status_bg = colors.none
    end
    highlights.NormalFloat = { fg = colors.fg, bg = float_bg }
    highlights.FloatBorder = { fg = colors.border_highlight, bg = float_bg }
    highlights.LspReferenceWrite = { underline = false, bg = colors.bg_highlight, standout = true }
    highlights.StatusLine = { fg = colors.fg, bg = status_bg }
    highlights.StatusLineNC = { fg = colors.fg_dark, bg = status_bg }
    highlights.TelescopeNormal = { fg = colors.fg, bg = tele_bg }
    highlights.TelescopeBorder = { fg = tele_bg, bg = tele_bg }
    highlights.TelescopePromptBorder = { fg = tele_bg, bg = tele_bg }
    highlights.TelescopePromptNormal = { bg = tele_bg }
    highlights.Pmenu = { bg = float_bg }
    highlights.PmenuSel = { fg = colors.blue, bg = colors.black }
    highlights["@text.literal.markdown_inline"] = { bg = colors.none }
    highlights.Todo = { fg = "#10B981", bg = colors.none }
    highlights.SignColumnSB = { bg = colors.none }
    highlights.IblScope = { fg = "#cccccc" }
    highlights.EoLSpace = { bg = "#884455" }
    highlights.FloatTitle = { fg = colors.bg, bg = colors.blue }
    highlights.TelescopePromptTitle = { bg = colors.blue }
    highlights.TelescopePreviewTitle = { bg = colors.blue }
    highlights.TelescopeResultsTitle = { bg = colors.blue }
    -- all link below
    highlights.NormalSB = { link = "Normal" }
    highlights.luaParenError = { link = "Normal" }
    highlights.SagaBorder = { link = "FloatBorder" }
    highlights.DiagnosticShowBorder = { link = "FloatBorder" }
    highlights.CmpCompletionBorder = { link = "FloatBorder" }
    highlights.CmpDocumentationBorder = { link = "FloatBorder" }
    highlights.LspInfoBorder = { link = "FloatBorder" }
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
  end,
})

vim.cmd([[colorscheme tokyonight]])
