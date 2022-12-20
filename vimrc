set nocompatible
filetype off

" ===== plugins via vim-plug ==================================================
" :PlugInstall - install
" :PlugUpdate - update or install
" :PlugClean - remove unlisted
" :PlugUpgrade - upgrade vim-plug
" :PlugStatus - plugins status
" :PlugDiff - pending changes (like a dry-run of :PlugUpdate)
" :PlugSnapshot [output-path] - generates a script to restore current state

call plug#begin('~/dev/vim-plug')
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" === My Plugins ===
Plug 'derekwyatt/vim-scala'
"Plug 'kien/rainbow_parentheses.vim' " This plugin doesn't work
Plug 'luochen1990/rainbow'
Plug 'nvim-lua/plenary.nvim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
" ==================

" example plugins below

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" ===== end plugins section ===================================================

" Enable rainbow parentheses plugin
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

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

" Draw a line across the window under the cursor
set cursorline

" Show relative line numbers, but absolute line number for the cursor line
set number relativenumber

"set undofile
set guioptions=T

let @p='0$F/ld^j@p'
