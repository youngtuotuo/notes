let g:plug_home = stdpath('data') . '/plugged'
call plug#begin()
" colorscheme
Plug 'nvim-lualine/lualine.nvim'
Plug 'ellisonleao/gruvbox.nvim'
" markdown
Plug 'ellisonleao/glow.nvim'
" color code highlight
Plug 'norcalli/nvim-colorizer.lua'
" git
Plug 'tpope/vim-fugitive'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'lewis6991/gitsigns.nvim'
" file explorer
Plug 'kyazdani42/nvim-tree.lua'
" treesitter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
" lsp
Plug 'SmiteshP/nvim-gps'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/cmp-treesitter'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ray-x/lsp_signature.nvim'
" TODO
Plug 'folke/todo-comments.nvim'
" zen mode
Plug 'folke/zen-mode.nvim'
" yank highlight
Plug 'machakann/vim-highlightedyank'
" comment
Plug 'tpope/vim-commentary'
" telescope
Plug 'nvim-telescope/telescope-fzy-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()
