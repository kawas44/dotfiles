" My vimrc
set nocompatible
scriptencoding utf-8

" Use Vim-Plug
call plug#begin('~/.vim/plugged')
    " basic edit
    "SEE: tpope/vim-sensible
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'maxbrunsfeld/vim-yankstack'
    Plug 'mbbill/undotree'

    " navigation
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'ctrlpvim/ctrlp.vim'

    " Color scheme
    Plug 'romainl/Apprentice'

    " File Explorer
    Plug 'tpope/vim-vinegar'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Clojure
    Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
    Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
    Plug 'guns/vim-sexp', { 'for': 'clojure' }
    Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
    Plug 'junegunn/rainbow_parentheses.vim', { 'for': 'clojure' }

    " Json
    Plug 'tpope/vim-jdaddy', { 'for': 'json' }
call plug#end()


" Unset Vi compatible mode and map Leader
set hidden
set autoread
let mapleader = ","

" Encoding stuff
set fileencodings=ucs-boom,utf-8,latin1

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Map up and down even in wrap lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap Y y$

" Navigate buffers
nnoremap <silent> <C-Tab> :bnext<CR>
nnoremap <silent> <C-S-Tab> :bprevious<CR>

" Numbers inc/dec
set nrformats-=octal

" Set visible characters and lines
set list
nnoremap <Leader>i :set list!<Bar>set list?<CR>
set listchars=tab:»\ ,trail:·
set nocursorline
set scrolloff=4
set sidescrolloff=5
set lazyredraw
set backspace=indent,eol,start

" Deal with spaces, tabs and lines
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nonumber
nnoremap <Leader>n :set number!<Bar>set number?<CR>
set nowrap
nnoremap <Leader>w :set invwrap<Bar>set wrap?<CR>

" Configure search and hightlight
set ignorecase
set smartcase
set incsearch
set nowrapscan
set hlsearch
nnoremap <Leader><space> :noh<CR>

" Use very magic search
nnoremap / /\v
xnoremap / /\v

" Fix '&' use, to apply last search with last flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Deal with mode and status line
set laststatus=2
set showcmd
set showmode
set cmdheight=2

set wildmenu
set wildmode=list:longest

set statusline=%-50(%F%m%r%h%w%)\ %(%y\ %{fugitive#statusline()}%{&fenc}\ %{&ff}%)\ %=%4l,%3c\ %3p%%

" Define backup rules
set backup
if has("unix")
    set backupdir=~/.backuptxt,.
elseif has("win32")
    set backupdir=c:/temp/_backuptxt,.
endif
set backupcopy=yes

" Set GUI options
set background=dark
colorscheme apprentice

if has("gui_running")
    set cursorline
    "set colorcolumn=80
    "highlight ColorColumn guibg=snow
    if has("win32")
        set lines=58 columns=86
        set guifont=Source_Code_Pro:h9:b:cDEFAULT
    elseif has("unix")
        set lines=52 columns=86
        set guifont=Monospace\ 10
    endif
    set guioptions-=T
    set guioptions+=bh
endif

" Set Clipboard options
if has('unnamedplus')
    set clipboard=autoselect,unnamedplus,exclude:cons\|linux
endif


" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
