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

    " neovim only
    Plug 'Lenovsky/nuake', {'on': 'Nuake'}

    " files & buffers
    Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins', 'tag': '2.1'}
    Plug 'KabbAmine/vZoom.vim', {'on': ['<Plug>(vzoom)', 'VZoomAutoToggle']}

    " completion
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins', 'tag': '5.1'}
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

" nuake
nnoremap <F11> :Nuake<CR>
inoremap <F11> <C-\><C-n>:Nuake<CR>
tnoremap <F11> <C-\><C-n>:Nuake<CR>

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


" }}}

" OPTIONS {{{

set hidden
set autoread
set updatetime=1000
set mouse=a

augroup Check_Changes
    autocmd!
    autocmd FocusGained,BufWinEnter,WinEnter * :checktime
augroup END

set nobackup
set writebackup
set undofile

if has("unix") || has("mac")
    set directory=~/.local/share/_vim/swap//,.
    set backupdir=~/.local/share/_vim/backup//,.
    set undodir=~/.local/share/_vim/undo//,.
endif

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

augroup Toggle_Cursorline
    autocmd!
    autocmd FocusGained,WinEnter * set cursorline
    autocmd FocusLost,WinLeave * set nocursorline
augroup END

" }}}

" MAPPINGS {{{

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

" }}}

" FUNCTIONS & COMMANDS {{{

" DiffOrig command to see the difference between the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" }}}
