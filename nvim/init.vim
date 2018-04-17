" My nvim config

set encoding=utf-8
let mapleader=" "
let maplocalleader="\\"


" PLUGINS {{{

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

call plug#begin('~/.local/share/nvim/plugged')
    " basic
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'mbbill/undotree'
    Plug 'mhinz/vim-grepper'
    Plug 'nelstrom/vim-visual-star-search'

    " files & buffers
    Plug 'vifm/neovim-vifm'
    Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}

    " completion
    Plug 'ajh17/VimCompletesMe'

    " vcs
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " clojure
    Plug 'guns/vim-clojure-static'
    Plug 'tpope/vim-fireplace'
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    Plug 'clojure-vim/vim-cider'
    Plug 'guns/vim-clojure-highlight'

    " rest
    Plug 'diepm/vim-rest-console'

    " colorscheme
    Plug 'rafi/awesome-vim-colorschemes'

call plug#end()

" undotree
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

" grepper
runtime plugin/grepper.vim
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.dir = 'repo,filecwd'
let g:grepper.prompt_quote = 2
let g:grepper.operator.prompt = 1
nnoremap <leader>g :Grepper<cr>
nmap gr <plug>(GrepperOperator)
xmap gr <plug>(GrepperOperator)

" vifm
let g:vifmLiveCwd = 0
nnoremap <F12> :edit %:p:h<cr>

" denite.nvim
call denite#custom#map('insert', '<C-J>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map( 'insert', '<C-K>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <silent> <leader>p :<C-U>Denite register<cr>

call denite#custom#alias('source', 'file_rg', 'file_rec')
call denite#custom#var('file_rg', 'command', ['rg', '--files', ''])
nnoremap <silent> <leader>o :<C-U>DeniteProjectDir -path=`expand('%:p:h')` buffer file_rg<cr>

" git
augroup my_git_aug
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != '' | nnoremap <buffer> <F9> :Gstatus<cr> | endif
augroup END

" cider
let g:refactor_nrepl_options = '{:prefix-rewriting false}'

" }}}

" OPTIONS {{{

set hidden
set autoread
set updatetime=500
augroup checktime_to_trigger_autoread
    autocmd!
    autocmd FocusGained,BufEnter * :checktime
augroup END

set backup
set backupdir=~/.local/share/nvim/backup
set undofile

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set ignorecase
set smartcase
set incsearch
set nowrapscan
set hlsearch

set ruler
set showcmd
set laststatus=2
set showmode
set cmdheight=2
set nonumber
set nowrap
set list
set listchars=tab:»\ ,trail:·,nbsp:‗
set nocursorline
set scrolloff=4
set sidescrolloff=5

set wildmenu
set wildmode=list:longest,full
set completeopt=menuone

set statusline=%-50(%F%m%r%h%w%)\ %(%y\ %{fugitive#statusline()}%{&fenc}\ %{&ff}%)\ %=%4l,%3c\ %3p%%

set lazyredraw

set splitbelow
set splitright

" set background=dark
colorscheme seoul256

augroup highlight_follows_focus
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

augroup highligh_follows_vim
    autocmd!
    autocmd FocusGained * set cursorline
    autocmd FocusLost * set nocursorline
augroup END

" }}}

" MAPPINGS {{{

" disable ex mode shortcut key
nnoremap Q <nop>

" coherent yank until end of line
nnoremap Y y$

" use arrows to resize window
nnoremap <up>    5<C-w>+
nnoremap <down>  5<C-w>-
nnoremap <left>  5<C-w>>
nnoremap <right> 5<C-w><

inoremap <up>    <C-o>5<C-w>+
inoremap <down>  <C-o>5<C-w>-
inoremap <left>  <C-o>5<C-w>>
inoremap <right> <C-o>5<C-w><

" move in virtual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap <leader><space> :noh<cr>
nnoremap <leader>w :update<cr>
" nnoremap <leader>n :set number!<bar>set number?<cr>
" nnoremap <leader>w :set invwrap<bar>set wrap?<cr>
nnoremap <leader>i :set list!<bar>set list?<cr>

" search using very magic
nnoremap / /\v
xnoremap / /\v

" repeat substitution keeping flags
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" break undo sequence in insert mode
inoremap <C-U> <C-G>u<C-U>

"copy/cut-paste
vnoremap <C-Insert> "+y
vnoremap <S-Del> "+ygvd
inoremap <S-Insert> <C-r><C-o>+

" }}}

" FUNCTIONS & COMMANDS {{{

" DiffOrig command to see the difference between the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" }}}
