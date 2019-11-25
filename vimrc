" My vimrc

set nocompatible
set encoding=utf-8
scriptencoding utf-8
let mapleader = " "
language en_US.utf8
let maplocalleader = "\\"

call plug#begin('~/.vim/plugged')
    " basic
    Plug 'tpope/vim-repeat'
    Plug 'machakann/vim-sandwich'
    Plug 'andymass/vim-matchup'
    Plug 'romainl/vim-qf'
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
    Plug 'Shougo/denite.nvim', {'tag': '2.1'}
    Plug 'KabbAmine/vZoom.vim', {'on': ['<Plug>(vzoom)', 'VZoomAutoToggle']}

    " completion
    Plug 'Shougo/deoplete.nvim', {'tag': '5.1'}
    Plug 'clojure-vim/async-clj-omni'
    Plug 'dense-analysis/ale'

    " marks & vcs
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'airblade/vim-gitgutter'

    " clojure
    Plug 'guns/vim-clojure-static'
    Plug 'tpope/vim-fireplace', {'tag': 'v1.2'}
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
    Plug 'clojure-vim/vim-cider'
    Plug 'guns/vim-clojure-highlight'

    " tags
    Plug 'ludovicchabant/vim-gutentags'

    " rest
    Plug 'diepm/vim-rest-console'

    " colorscheme
    Plug 'rafi/awesome-vim-colorschemes'

    " neovim compatibility
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'

call plug#end()

" matchup
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_status_offscreen = 0

" qf
let g:qf_mapping_ack_style = 1
nmap <leader>q <Plug>(qf_qf_switch)

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

" sneak
let g:sneak#label = 1

" denite.nvim
call denite#custom#map('insert', '<C-J>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map( 'insert', '<C-K>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <silent> <leader>p :<C-U>Denite -split=no -reversed register<cr>

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
nnoremap <silent> <leader>o :<C-U>DeniteProjectDir -split=no -reversed -path=`expand('%:p:h')` file/rec<cr>

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
nnoremap <silent> <leader>l :<C-U>Denite grep:::!<cr>

" vzoom
nmap <leader>z <Plug>(vzoom)

" deoplete
let g:deoplete#enable_at_startup = 1

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] %(code): %%s [%linter%]'

nmap <silent> [l <Plug>(ale_previous_wrap)
nmap <silent> ]l <Plug>(ale_next_wrap)

" git
augroup Set_Git_Mapping
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != '' | nnoremap <buffer> <F9> :Gstatus<cr> | nnoremap <buffer> <F10> :Flog<cr> | endif
augroup END

" gutentags
let g:gutentags_ctags_exclude = ["target", "resources"]

" cider
let g:refactor_nrepl_options = {'prefix-rewriting': 'false', 'prune-ns-form': 'true', 'remove-consecutive-blank-lines': 'false' }

" netrw
autocmd FileType netrw setlocal bufhidden=wipe

let g:netrw_liststyle = 3
nmap <F12> :Explore<CR>



" Set basic behavior
set hidden
set autoread
set updatetime=1000
set mouse=a

set nobackup
set writebackup
set undofile

if has("unix") || has("mac")
    set directory=~/.local/share/_vim/swap//,.
    set backupdir=~/.local/share/_vim/backup//,.
    set undodir=~/.local/share/_vim/undo//,.
endif

" Various options
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set ignorecase
set smartcase
set incsearch
set nowrapscan
set hlsearch
set report=0

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

set spelllang=en_us
set complete+=kspell

set statusline=%-50(%F%m%r%h%w%)\ %(%y\ %{fugitive#statusline()}%{&fenc}\ %{&ff}%)\ %=%4l,%3c\ %3p%%

set lazyredraw
set synmaxcol=300

set splitbelow
set splitright

set diffopt=internal,filler,indent-heuristic,algorithm:histogram

set background=dark
colorscheme seoul256
let &t_ut=''

" Encoding stuff
set fileencodings=ucs-boom,utf-8,latin1

" Numbers inc/dec
set nrformats-=octal

" Deal with special edits
set backspace=indent,eol,start


" MAPPINGS

" disable ex mode shortcut key
nnoremap Q <nop>

" coherent yank until end of line
nnoremap Y y$

" visual shift keep selection
xnoremap <  <gv
xnoremap >  >gv

" use arrows to resize window
" nnoremap <up>    5<C-w>+
" nnoremap <down>  5<C-w>-
" nnoremap <left>  5<C-w>>
" nnoremap <right> 5<C-w><

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
nnoremap <leader>i :set list!<bar>set list?<cr>

" search using very magic
nnoremap / /\v
xnoremap / /\v

" repeat substitution keeping flags
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" break undo sequence in insert mode
inoremap <C-U> <C-G>u<C-U>

" unimpaired like
nnoremap [b :<C-U>bprevious<cr>
nnoremap ]b :<C-U>bnext<cr>
nnoremap [B :<C-U>bfirst<cr>
nnoremap ]B :<C-U>blast<cr>

nnoremap [t :<C-U>tabprevious<cr>
nnoremap ]t :<C-U>tabnext<cr>
nnoremap [T :<C-U>tabfirst<cr>
nnoremap ]T :<C-U>tablast<cr>

nnoremap [q :<C-U>cprevious<cr>
nnoremap ]q :<C-U>cnext<cr>
nnoremap [Q :<C-U>cfirst<cr>
nnoremap ]Q :<C-U>clast<cr>

" spelling
nnoremap <leader>k :<C-U>set spell!<bar>set spell?<cr>


" Set GUI options

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

