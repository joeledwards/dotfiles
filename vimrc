set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" Plugin 'VundleVim/Vundle.vim'

" Is this needed
"source %
"PluginInstall

" plugins
"Plugin 'ntpeters/vim-better-whitespace'
"Plugin 'tpope/vim-fugitive'
"Plugin 'junegunn/fzf'
"Plugin 'yggdroot/indentlilne'
"Plugin 'scoolroose/nerdtree'
"Plugin 'kien/rainbow_parentheses.vim'
"Plugin 'Valloric/YouCompleteMe'

" All plugins before here
" call vundle#end()
filetype plugin indent on


" my Vim configuration
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
set cindent
set cinkeys-=0#
set indentkeys-=0#

set cursorline
set relativenumber
"set undofile
set guioptions=T

let @p='0$F/ld^j@p'
