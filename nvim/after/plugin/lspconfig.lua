local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then return end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then return end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then return end

local kind_status_ok, lspkind = pcall(require, "lspkind")
if not kind_status_ok then return end

local util = require("lspconfig.util")

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('lsp_document_highlight', {clear = false})
        vim.api.nvim_clear_autocmds({buffer = bufnr, group = 'lsp_document_highlight'})
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references
        })
    end

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings.
    local opts = {noremap = true, silent = false}
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

require("neodev").setup {}

require("mason").setup({ui = {border = "rounded"}})

-- Ensure the servers above are installed
local servers = {"sumneko_lua", "pyright", "clangd", "rust_analyzer", "texlab"}
require("mason-lspconfig").setup {ensure_installed = servers}

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"}),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        lspconfig[server_name].setup({on_attach = on_attach, handlers = handlers, capabilities = capabilities})
    end,
    -- Next, you can provide targeted overrides for specific servers.
    ["sumneko_lua"] = function()
        lspconfig.sumneko_lua.setup {
            on_attach = on_attach,
            handlers = handlers,
            capabilities = capabilities,
            root_dir = util.root_pattern(unpack({
                ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml",
                "selene.yml", ".git"
            })),
            settings = {
                Lua = {
                    runtime = {version = "Lua 5.1"},
                    diagnostics = {globals = {'vim', 'use'}},
                    completion = {callSnippet = "Both"},
                    workspace = {checkThirdParty = false},
                    semantic = {enable = false}
                }
            }
        }
    end,
    ["pyright"] = function()
        lspconfig.pyright.setup {
            on_attach = on_attach,
            handlers = handlers,
            capabilities = capabilities,
            root_dir = util.root_pattern(unpack({
                'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json',
                'pyvenv.cfg'
            })),
            settings = {
                pyright = {
                    -- Disables the “Organize Imports” command. This is useful if you are using another extension that provides similar functionality and you don’t want the two extensions to fight each other.
                    disableOrganizeImports = false
                },
                python = {
                    analysis = {
                        -- Level of logging for Output panel. The default value for this option is "Information".
                        -- ["Error", "Warning", "Information", or "Trace"]
                        logLevel = "Information",
                        -- Determines whether pyright offers auto-import completions.
                        autoImportCompletions = true,
                        -- Determines whether pyright automatically adds common search paths like "src" if there are no execution environments defined in the config file.
                        autoSearchPaths = true,
                        -- Determines whether pyright analyzes (and reports errors for) all files in the workspace, as indicated by the config file. If this option is set to "openFilesOnly", pyright analyzes only open files.
                        -- ["openFilesOnly", "workspace"]
                        diagnosticMode = "workspace",
                        -- Path to directory containing custom type stub files.
                        -- stubPath = {},
                        -- Determines the default type-checking level used by pyright. This can be overridden in the configuration file. (Note: This setting used to be called "pyright.typeCheckingMode". The old name is deprecated but is still currently honored.)
                        -- ["off", "basic", "strict"]
                        typeCheckingMode = "off",
                        -- Determines whether pyright reads, parses and analyzes library code to extract type information in the absence of type stub files. Type information will typically be incomplete. We recommend using type stubs where possible. The default value for this option is false.
                        useLibraryCodeForTypes = false
                    }
                }
            }
        }
    end,
    ['texlab'] = function()
        lspconfig.texlab.setup {
            on_attach = on_attach,
            handlers = handlers,
            capabilities = capabilities,
            settings = {
                texlab = {
                    rootDirectory = nil,
                    build = {
                        executable = 'latexmk',
                        args = {'-xelatex', '-interaction=nonstopmode', '-synctex=1', '%f'},
                        -- executable = 'xelatex',
                        onSave = false,
                        forwardSearchAfter = false
                    },
                    auxDirectory = '.',
                    forwardSearch = {executable = nil, args = {}},
                    chktex = {onOpenAndSave = false, onEdit = false},
                    diagnosticsDelay = 300,
                    latexFormatter = 'latexindent',
                    latexindent = {
                        ['local'] = nil, -- local is a reserved keyword
                        modifyLineBreaks = false
                    },
                    bibtexFormatter = 'texlab',
                    formatterLineLength = 80
                }
            }
        }
    end
})

require('lspconfig.ui.windows').default_options.border = 'rounded'

local signs = {
    {name = "DiagnosticSignError", text = ""}, {name = "DiagnosticSignWarn", text = ""},
    {name = "DiagnosticSignHint", text = ""}, {name = "DiagnosticSignInfo", text = ""}
}

for _, sign in ipairs(signs) do vim.fn.sign_define(sign.name, {texthl = sign.name, text = sign.text, numhl = ""}) end

-- diagnostic after each line
local diag_config = {
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {focusable = false, style = "minimal", source = "always", header = "", prefix = "σ`∀´)σ "},
    source = true
}

vim.diagnostic.config(diag_config)

require("luasnip.loaders.from_vscode").lazy_load()

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("cmp").setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    }),
    enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
    end,
    complettion = {autocomplete = false},
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({'path'}, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return lspkind.cmp_format({
                mode = 'symbol_text',
                with_text = false,
                maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    path = "[Path]",
                    nvim_lua = "[NvimLua]",
                    cmdline = "[Cmd]"
                })
            })(entry, vim_item)
        end
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'buffer'}, {name = 'luasnip', keyword_length = 3}, {name = 'path'},
        {name = 'nvim_lua'}
    }),
    sorting = {comparators = {cmp.config.compare.score, cmp.config.compare.offset}},
    experimental = {native_menu = false, ghost_text = false}
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({'/', '?'}, {mapping = cmp.mapping.preset.cmdline(), sources = {{name = 'buffer'}}})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline', keyword_length = 2}})
})

