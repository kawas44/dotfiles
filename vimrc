" My vimrc
set nocompatible
set encoding=utf-8
scriptencoding utf-8
let mapleader = " "

" Define Vim plugins
call plug#begin('~/.vim/plugged')
    " basic edit
    "SEE: tpope/vim-sensible
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'maxbrunsfeld/vim-yankstack'
    Plug 'mbbill/undotree'
    Plug 'ConradIrwin/vim-bracketed-paste'
    Plug 'neitanod/vim-clevertab'

    " navigation
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'mhinz/vim-grepper'

    " Color scheme
    Plug 'romainl/Apprentice'

    " File Explorer
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-dispatch'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Clojure
    Plug 'guns/vim-clojure-static'
    Plug 'tpope/vim-fireplace'
    Plug 'tpope/vim-salve'
    Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
    Plug 'guns/vim-sexp', { 'for': 'clojure' }
    Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

    " Json
    Plug 'tpope/vim-jdaddy', { 'for': 'json' }

    " Rest
    Plug 'diepm/vim-rest-console', { 'for': 'rest' }
call plug#end()

" vim-yankstack
let g:yankstack_map_keys = 0
call yankstack#setup()
nmap <Leader>r <Plug>yankstack_substitute_older_paste
nmap <Leader>R <Plug>yankstack_substitute_newer_paste

" vim-clevertab
inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('user')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>

" vim-grepper
runtime plugin/grepper.vim
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.dir = 'repo,filecwd'

nnoremap \ :Grepper<CR>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" vim-fugitive
nmap <silent> <leader>gs :Gstatus<CR>rgg<C-n>

" Load matchit.vim, but only if the user hasn't installed a newer version.
" may use 'https://github.com/adelarsq/vim-matchit' instead
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


" Set basic behavior
set hidden
set autoread

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

" Disable Ex-mode
nnoremap Q <nop>

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

" Deal with special edits
set backspace=indent,eol,start
inoremap <C-U> <C-G>u<C-U>

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
set wildmode=list:longest,full

set statusline=%-50(%F%m%r%h%w%)\ %(%y\ %{fugitive#statusline()}%{&fenc}\ %{&ff}%)\ %=%4l,%3c\ %3p%%

" Define backup rules
set backup
if has("unix")
    set backupdir=~/.backuptxt,.
elseif has("win32")
    set backupdir=c:/temp/_backuptxt,.
endif
set backupcopy=auto

" Set GUI options
set background=dark
colorscheme apprentice

if has("gui_running")
    set cursorline
    "set colorcolumn=80
    "highlight ColorColumn guibg=snow
    if has("win32")
        set lines=58 columns=128
        set guifont=Source_Code_Pro:h9:b:cDEFAULT
    elseif has("unix")
        set lines=52 columns=128
        set guifont=Monospace\ 10
    endif
    " remove toolbar
    set guioptions-=T
    " remove scrollbars
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    "set guioptions+=bh
endif

" Set Clipboard options
if has('unix')
    set clipboard=autoselect,exclude:cons\|linux
endif

