set noerrorbells
set novisualbell
set nowritebackup
set noswapfile
set nobackup
set mouse=a
set guicursor=
set nohidden
set laststatus=0
set fillchars=stl: 
set winbar=%=%m\ %f
set formatoptions=tqj
" netrw
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_bufsettings = 'nocursorline'
let g:loaded_python3_provider = 0
" Parathensis match
set showmatch
set matchtime=5
" Search control
set ignorecase
set smartcase
set splitbelow
set splitright
set viminfo='1000
set showmode

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout=700})
augroup end

" <tab> control
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
autocmd FileType cpp,c,vim,yaml setlocal shiftwidth=2 tabstop=2

set updatetime=400

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

syntax on
filetype indent on

runtime plugs.vim
runtime cfg/cmpcfg.vim
runtime cfg/lspcfg.vim
runtime cfg/telescopecfg.vim
runtime cfg/todo.vim
runtime cfg/treesittercfg.vim
runtime cfg/color.vim
runtime cfg/markdownpreview.vim
runtime maps.vim
