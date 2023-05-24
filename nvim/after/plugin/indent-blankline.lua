vim.opt.list = true
vim.opt.listchars = "eol:⏎"
require("indent_blankline").setup {
    enabled = true,
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false,
    show_first_indent_level = false,
    show_end_of_line = true,
    show_trailing_blankline_indent = false,
}

