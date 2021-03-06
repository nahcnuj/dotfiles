filetype off

set encoding=utf-8
set fileencoding=utf-8          " for writing
set fileencodings=utf-8,euc-jp,cp932   " for reading
set ambiwidth=double

set wrap

set wrapscan
set hlsearch
set noignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

set ruler
set number

set list
set listchars=tab:»-,trail:-,eol:￬,extends:»,precedes:«,nbsp:%

set wildmenu
set showcmd

set clipboard=unnamed,autoselect

set writebackup

set mouse=a
set ttymouse=xterm2

syntax on
colorscheme desert

" Markdown
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown

filetype plugin indent on
