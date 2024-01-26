-- stylua: ignore start

-- print(vim.inspect(v))
P = function(v) print(vim.inspect(v)) return v end

-- "none": No border (default).
-- "single": A single line box.
-- "double": A double line box.
-- "rounded": Like "single", but with rounded corners ("╭" etc.).
-- "solid": Adds padding by a single whitespace cell.
-- "shadow": A drop shadow effect by blending with the
_G.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
_G.floatw = 120
_G.floatwrap = false

-- file types to trigger nvim-lspconfig
_G.lspfts = { "c", "lua", "cpp", "python", "rust", "zig", "go" }

-- fk u MS
_G.sep = vim.fn.has("win32") == 1 and [[\]] or "/"
_G.home = vim.fn.has("win32") == 1 and "USERPROFILE" or "HOME"
_G.ext = vim.fn.has("win32") == 1 and ".exe" or ""

local trsp = "none"
local y, r, b, g, c = "NvimLightYellow", "NvimLightRed", "NvimLightBlue", "NvimLightGreen", "NvimLightCyan"
local gr = "NvimLightGrey4"
local w = "NvimLightGrey1"
local dgr3 = "NvimDarkGrey3"
local dgr1 = "#26233a"
local selfg = "#e0def4"

_G.colorset = function()
  local hls = {
    Error              = { fg = trsp },
    netrwMarkFile      = { fg = y    },
    markdownBlockquote = { fg = gr   },
    PmenuSel           = { fg = w    },

    WinBar           = { bg = trsp },
    WinBarNC         = { bg = trsp },
    NormalFloat      = { bg = trsp },
    FloatTitle       = { bg = trsp },
    LspReferenceText = { bg = dgr1 },


    ModeMsg            = { fg = w,     bold = true },
    TelescopeSelection = { fg = selfg, bold = true },

    DiagnosticFloatingOk    = { fg = g,    bg = trsp },
    DiagnosticFloatingHint  = { fg = b,    bg = trsp },
    DiagnosticFloatingInfo  = { fg = c,    bg = trsp },
    DiagnosticFloatingWarn  = { fg = y,    bg = trsp },
    DiagnosticFloatingError = { fg = r,    bg = trsp },
    FoldColumn              = { fg = dgr3, bg = trsp },

    LspReferenceRead     = { link = "LspReferenceText" },
    LspReferenceWrite    = { link = "LspReferenceText" },
    IlluminatedWordText  = { link = "LspReferenceText" },
    IlluminatedWordWrite = { link = "LspReferenceText" },
    IlluminatedWordRead  = { link = "LspReferenceText" },
    DiffAdd              = { link = "DiagnosticFloatingOk" },
    DiffChange           = { link = "DiagnosticFloatingWarn" },
    DiffDelete           = { link = "DiagnosticFloatingError" },
    LspInfoBorder        = { link = "Label" },
    FloatBorder          = { link = "LspInfoBorder" },
    TelescopeBorder      = { link = "LspInfoBorder" },
  }
  if vim.o.laststatus == 0 then
    hls.StatusLine   = { link = "WinSeparator" }
    hls.StatusLineNC = { link = "WinSeparator" }
  end
  for k, v in pairs(hls) do
    vim.api.nvim_set_hl(0, k, v)
  end

  -- stylua: ignore
  -- update the last line
  local path = os.getenv(_G.home) .. "/github/dotfiles/nvim/init.lua"

  local file = io.open(path, "r")
  local fileContent = {}
  for line in file:lines() do
    table.insert(fileContent, line)
  end

  io.close(file)
  local name = vim.g.colors_name
  if name == nil then
    name = "default"
  end
  fileContent[#fileContent] = "vim.cmd[[colo " .. name .. "]]"

  file = io.open(path, "w")
  for _, value in ipairs(fileContent) do
    file:write(value .. "\n")
  end
  io.close(file)

  if vim.fn.expand("%:p") == path then
    vim.cmd([[e ]])
  end
end
_G.colorset()
