local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then return end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then return end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then return end

local kind_status_ok, lspkind = pcall(require, "lspkind")
if not kind_status_ok then return end

local util = require("lspconfig.util")

-- "none": No border (default).
-- "single": A single line box.
-- "double": A double line box.
-- "rounded": Like "single", but with rounded corners ("╭" etc.).
-- "solid": Adds padding by a single whitespace cell.
-- "shadow": A drop shadow effect by blending with the
local border = "rounded"

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
    -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
    -- buf_set_keymap('n', '<space>ic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    -- buf_set_keymap('n', '<space>oc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- buf_set_keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    -- buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

require("neodev").setup({})

require("mason").setup({ui = {border = border}})

-- Ensure the servers above are installed
local servers = {"lua_ls", "clangd", "rust_analyzer", "texlab", "html", "pyright"}
require("mason-lspconfig").setup {ensure_installed = servers}

-- local hover = function(_, result, ctx, config)
--   if not (result and result.contents) then
--     return vim.lsp.handlers.hover(_, result, ctx, config)
--   end
--   if type(result.contents) == "string" then
--     local s = string.gsub(result.contents or "", "&nbsp;", " ")
--     s = string.gsub(s, [[\\\n]], [[\n]])
--     result.contents = s
--     return vim.lsp.handlers.hover(_, result, ctx, config)
--   else
--     local s = string.gsub((result.contents or {}).value or "", "&nbsp;", " ")
--     s = string.gsub(s, "\\\n", "\n")
--     result.contents.value = s
--     return vim.lsp.handlers.hover(_, result, ctx, config)
--   end
-- end

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- relative = 'mouse',
        -- anchor = 'NE',
        -- row = 0,
        -- col = 0.9,
        max_width=80,
        border = border,
        title = '(*´ω`)人(´ω`*)',
    }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = border, max_width = 80})
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
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
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

require('lspconfig.ui.windows').default_options.border = border

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
    update_in_insert = true,
    severity_sort = true,
    float = {focusable = false, style = "minimal", source = "always", header = "σ`∀´)σ", border=border},
    source = true
}

vim.diagnostic.config(diag_config)

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    window = {
        completion = {
            border = border,
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 1,
            side_padding = 0,
        },
        documentation = {
            border = border,
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            max_width = 40,
            max_height = 20,
        }
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
        ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"})
    }),
    enabled = function()
        -- disable completion in comments
        local context = require 'cmp.config.context'
        local tele_prompt = vim.bo.filetype == 'TelescopePrompt'
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        elseif tele_prompt then
            return false
        else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
    end,
    complettion = {autocomplete = false},
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            if vim.tbl_contains({'path'}, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            local kind = lspkind.cmp_format({
                -- 'text', 'text_symbol', 'symbol_text', 'symbol'
                mode = 'symbol_text',
                maxwidth = 20, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                menu = ({
                    buffer = "[BUFF]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[SNIP]",
                    path = "[PATH]",
                    nvim_lua = "[LUA]",
                    cmdline = "[CMD]"
                })
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "     (" .. (strings[2] or "") .. ")" .. " " .. (kind.menu or "")
            return kind
        end
    },
    sources = cmp.config.sources({
        {name = 'luasnip'},
        {name = 'nvim_lsp'}, {name = 'buffer'},
        {name = 'path', keyword_length = 3}, {name = 'nvim_lua'},
        {name = 'nvim_lsp_signature_help'}
    }),
    sorting = {
        comparators = {
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    },
    experimental = { ghost_text = false }
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({'/', '?'}, {mapping = cmp.mapping.preset.cmdline(), sources = {{name = 'buffer'}}})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline', keyword_length = 2}})
})

require("lspsaga").setup({
    preview = {
        lines_above = 0,
        lines_below = 10,
    },
    scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    },
    request_timeout = 2000,
    ui = {
        title = true,
        border = border,
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = ' ',
        kind = {},
    },
    finder = {
        --percentage
        max_height = 0.5,
        min_width = 30,
        force_max_height = false,
        keys = {
          jump_to = 'p',
          edit = { 'o', '<CR>' },
          vsplit = 's',
          split = 'i',
          tabe = 't',
          tabnew = 'r',
          quit = { 'q', '<ESC>' },
          close_in_preview = '<ESC>'
        },
    },
    outline = {
        win_position = "left",
        win_with = "",
        win_width = 30,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {
          jump = "o",
          expand_collapse = "u",
          quit = "q",
        },
    },
    definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>i",
        tabe = "<C-c>t",
        quit = "q",
    },
    diagnostic = {
        on_insert = true,
        on_insert_follow = false,
        insert_winblend = 0,
        show_virt_line = true,
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
         --1 is max
        max_width = 0.5,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        border_follow = true,
        keys = {
          exec_action = "o",
          quit = "q",
          go_action = "g"
        },
    },
    callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "s",
          split = "i",
          tabe = "t",
          jump = "o",
          quit = "q",
          expand_collapse = "u",
        },
    },
    lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = false,
        sign_priority = 40,
        virtual_text = true,
    },
    symbol_in_winbar = {
        enable = true,
        separator = " 〉",
        ignore_patterns={},
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = false,
      },
})

-- lsp saga
local keymap = vim.keymap.set

-- Increment rename
keymap("n", "gn", ":IncRename ")

-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>")

-- Code action
keymap({"n","v"}, "ga", "<cmd>Lspsaga code_action<CR>")

-- Rename all occurrences of the hovered word for the entire file
-- keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

-- Rename all occurrences of the hovered word for the selected files
-- keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

-- Go to definition
-- keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")

-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

-- Go to type definition
-- keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")


-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show cursor diagnostics
-- Like show_line_diagnostics, it supports passing the ++unfocus argument
-- keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Show buffer diagnostics
-- keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
-- keymap("n", "gl", "<cmd>Lspsaga show_diagnostics<CR>")

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")

-- Diagnostic jump with filters such as only jumping to an error
-- keymap("n", "[E", function()
--   require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end)
-- keymap("n", "]E", function()
--   require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end)

-- Toggle outline
keymap("n","<space>o", "<cmd>Lspsaga outline<CR>")

-- Hover Doc
-- If there is no hover doc,
-- there will be a notification stating that
-- there is no information available.
-- To disable it just use ":Lspsaga hover_doc ++quiet"
-- Pressing the key twice will enter the hover window
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
-- keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

-- Call hierarchy
keymap("n", "<space>ic", "<cmd>Lspsaga incoming_calls<CR>")
keymap("n", "<space>oc", "<cmd>Lspsaga outgoing_calls<CR>")

-- Floating terminal
-- keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
