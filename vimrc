set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

colorscheme koehler

syntax on
set backspace=2
set ruler

set showcmd
set showmatch
set autoindent

set foldenable
set foldmethod=marker

set incsearch
set hlsearch
set ignorecase
set smartcase

set expandtab
set shiftwidth=2
set smartindent
set softtabstop=2
set ts=2
set splitright

set cursorline
set relativenumber
"set undofile
set guioptions=T

let @p='0$F/ld^j@p'

Bundle 'gmarik/vundle'
Bundle 'genoma/vim-less'

