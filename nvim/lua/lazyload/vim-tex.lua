vim.g.vimtex_view_method = "(has('win32') ? 'general':'zathura')"
vim.g.tex_flavor = "latex"
vim.g.vimtex_compiler_latexmk_engines = {
 _ = '-xelatex',
}
vim.g.vimtex_quickfix_enabled = 0
vim.opt.conceallevel=2
-- Vimtex
vim.api.nvim_set_keymap(
    "n",
    "<leader>vc",
    ":VimtexCompile<CR>",
    {
        noremap = true,
        silent = true
    }
)