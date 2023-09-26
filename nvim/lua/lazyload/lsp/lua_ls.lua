local g = require("tuo.global")
local config = function(capabilities, util)
  return {
    handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = g.border,
        title = " LuaLS ",
        max_width = 100,
        zindex = 500,
      }),
      ["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = g.border, title = " LuaLS ", max_width = 100 }
      ),
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = false,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = true,
          source = "always",
          title = " LusLS σ`∀´)σ ",
          border = g.border,
          max_width = 80,
        },
        source = true,
      }),
    },
    capabilities = capabilities,
    root_dir = util.root_pattern(unpack({
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    })),
    settings = {
      Lua = {
        runtime = { version = "Lua 5.1" },
        diagnostics = { globals = { "vim", "use" } },
        completion = { callSnippet = "Both" },
        workspace = { checkThirdParty = false },
        semantic = { enable = false },
      },
    },
  }
end

return config
