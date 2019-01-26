" My vimrc

set nocompatible
set encoding=utf-8
scriptencoding utf-8
let mapleader = " "
language en_US.utf8
let maplocalleader = "\\"

" Define Vim plugins
call plug#begin('~/.vim/plugged')
    " basic edit
    "SEE: tpope/vim-sensible
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'mbbill/undotree'

    " navigate
    Plug 'mhinz/vim-grepper'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'justinmk/vim-sneak'

    " vim only
    Plug 'ConradIrwin/vim-bracketed-paste'
    Plug 'tpope/vim-dispatch'

    " files & buffers
    Plug 'Shougo/denite.nvim'
    Plug 'KabbAmine/vZoom.vim'

    " completion
    Plug 'Shougo/deoplete.nvim'
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

    " neovim compatibility
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'

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

" denite.nvim
call denite#custom#map('insert', '<C-J>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map( 'insert', '<C-K>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <silent> <leader>p :<C-U>Denite -reversed register<cr>

call denite#custom#alias('source', 'file_rg', 'file_rec')
call denite#custom#var('file_rg', 'command', ['rg', '--files', ''])
nnoremap <silent> <leader>o :<C-U>DeniteProjectDir -reversed -path=`expand('%:p:h')` buffer file_rg<cr>

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

" Load matchit.vim, but only if the user hasn't installed a newer version.
" may use 'https://github.com/adelarsq/vim-matchit' instead
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


" Set basic behavior
set hidden
set autoread
set updatetime=500

" Encoding stuff
set fileencodings=ucs-boom,utf-8,latin1

" Disable arrow keys
nnoremap <up>    5<C-w>+
nnoremap <down>  5<C-w>-
nnoremap <left>  5<C-w><
nnoremap <right> 5<C-w>>
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

" Set split position
set splitbelow
set splitright

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
set completeopt=menuone
set backspace=indent,eol,start
inoremap <C-U> <C-G>u<C-U>

" Deal with spaces, tabs and lines
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nonumber
" nnoremap <Leader>n :set number!<Bar>set number?<CR>
set nowrap
" nnoremap <Leader>w :set invwrap<Bar>set wrap?<CR>

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

if has("unix")
    set directory=~/.vim/swap//,~/tmp//,/var/tmp//,/tmp//
endif

" Set GUI options
set background=dark
colorscheme gruvbox
let &t_ut=''

if has("gui_running")
    set cursorline
    "set colorcolumn=80
    "highlight ColorColumn guibg=snow
    if has("win32")
        set lines=58 columns=128
        set guifont=Source_Code_Pro:h9:b:cDEFAULT
    elseif has("mac")
        set lines=52 columns=128
        set guifont=Source\ Code\ Pro:h13
    elseif has("unix")
        set lines=52 columns=128
        set guifont=Source\ Code\ Pro\ 12
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

