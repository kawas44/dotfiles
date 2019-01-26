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

    " navigate
    Plug 'mhinz/vim-grepper'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'justinmk/vim-sneak'

    " neovim only
    Plug 'Lenovsky/nuake'

    " files & buffers
    Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'KabbAmine/vZoom.vim'

    " completion
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'clojure-vim/async-clj-omni'

    " marks & vcs
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-fugitive'
    Plug 'jreybert/vimagit'
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

" nuake
nnoremap <F11> :Nuake<CR>
inoremap <F11> <C-\><C-n>:Nuake<CR>
tnoremap <F11> <C-\><C-n>:Nuake<CR>

" denite.nvim
call denite#custom#map('insert', '<C-J>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map( 'insert', '<C-K>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <silent> <leader>p :<C-U>Denite -reversed register<cr>

call denite#custom#alias('source', 'file_rg', 'file_rec')
call denite#custom#var('file_rg', 'command', ['rg', '--files', ''])
nnoremap <silent> <leader>o :<C-U>DeniteProjectDir -reversed -path=`expand('%:p:h')` file_rg<cr>

" vzoom
nmap <leader>z <Plug>(vzoom)

" deoplete
let g:deoplete#enable_at_startup = 1

" git
augroup my_git_aug
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != '' | nnoremap <buffer> <F9> :MagitOnly<cr> | endif
augroup END

" cider
let g:refactor_nrepl_options = '{:prefix-rewriting false}'

" netrw
autocmd FileType netrw setlocal bufhidden=delete

let g:netrw_liststyle = 3
nmap <F12> :Explore<CR>


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

set background=dark
colorscheme seoul256
let &t_ut=''

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
nnoremap <S-Insert> i<C-r><C-o>+<Esc>

" }}}

" FUNCTIONS & COMMANDS {{{

" DiffOrig command to see the difference between the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" }}}
