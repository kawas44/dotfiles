" My nvim config

set encoding=utf-8
let mapleader = " "
let maplocalleader = "\\"

" PLUGINS {{{
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

call plug#begin('~/.local/share/nvim/plugged')
    " basic
    Plug 'tpope/vim-repeat'
    Plug 'machakann/vim-sandwich'
    Plug 'andymass/vim-matchup'
    Plug 'yssl/QFEnter'
    Plug 'sk1418/QFGrep'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'mbbill/undotree'
    Plug 'KabbAmine/vZoom.vim'

    Plug 'inkarkat/vim-ingo-library'
    Plug 'inkarkat/vim-AdvancedSorters'

    " navigate
    Plug 'mhinz/vim-grepper'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'justinmk/vim-sneak'

    " terminal
    Plug 'voldikss/vim-floaterm'

    " files & buffers
    Plug 'vifm/vifm.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " completion
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'fgrsnau/ncm2-otherbuf'

    " linting
    Plug 'dense-analysis/ale'

    " marks & vcs
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'airblade/vim-gitgutter'

    " clojure
    Plug 'guns/vim-clojure-static'
    Plug 'guns/vim-clojure-highlight'
    Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'

    Plug 'tpope/vim-fireplace'
    Plug 'clojure-vim/async-clj-omni'

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
let g:matchup_matchparen_stopline = 1000  " for match highlighting only

" undotree
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

" vzoom
nmap <leader>z <Plug>(vzoom)

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
nmap <leader>s <Plug>Sneak_s
nmap <leader>S <Plug>Sneak_S

" floaterm
nnoremap <silent> <F11> :FloatermToggle guake<CR>
tnoremap <silent> <F11> <C-\><C-n>:FloatermToggle guake<CR>

" vifm
nnoremap <silent> <F12> :Vifm<CR>

" fzf
let $FZF_DEFAULT_COMMAND = 'fd -t f -c never'
let g:fzf_preview_window = ''
let g:fzf_layout = { 'window': 'enew' }
nnoremap <silent> <leader>o :<C-U>Files<cr>

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
let g:ncm2#complete_delay = 300
let g:ncm2#popup_delay = 100
let g:ncm2#popup_limit = 40

let g:ncm2#matcher = {
\ 'name': 'must',
\ 'matchers': [
\   {'name': 'base_min_len', 'value': 3},
\   'prefix',
\ ]}

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] %(code): %%s [%linter%]'

let g:ale_pattern_options = {
\ 'project\.clj$': {'ale_linters': [], 'ale_fixers': []},
\ 'profiles\.clj$': {'ale_linters': [], 'ale_fixers': []},
\ }

nmap <silent> [l <Plug>(ale_previous_wrap)
nmap <silent> ]l <Plug>(ale_next_wrap)

" git
augroup Set_Git_Mapping
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != ''
                \ | nnoremap <silent> <buffer> <F9> :Gtabedit :<cr>
                \ | nnoremap <buffer> <F10> :Flog -date=short<cr>
                \ | endif
augroup END

" gutentags
let g:gutentags_ctags_exclude = ["target", "resources", "tmp"]

" clojure-static
let g:clojure_maxlines = 500
let g:clojure_align_multiline_strings = 1


" netrw
" autocmd FileType netrw setlocal bufhidden=wipe
" let g:netrw_liststyle = 3
" nmap <F12> :Explore<CR>

" }}}

" OPTIONS {{{
set hidden
set autoread
set autowrite
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
    set directory=~/.local/share/nvim/swap//,.
    set backupdir=~/.local/share/nvim/backup//,.
    set undodir=~/.local/share/nvim/undo//,.
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
set completeopt=menuone,noinsert,noselect

set spelllang=en_us
set complete+=kspell

set title
set statusline=%-50(%F%m%r%h%w%)\ %(%y\ %{fugitive#statusline()}%{&fenc}\ %{&ff}%)\ %=%4l,%3c\ %3p%%

set lazyredraw
set synmaxcol=300

set splitbelow
set splitright

set diffopt=internal,filler,indent-heuristic,algorithm:histogram

set termguicolors
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
nnoremap <S-Up>    5<C-w>+
nnoremap <S-Down>  5<C-w>-
nnoremap <S-Left>  5<C-w>>
nnoremap <S-Right> 5<C-w><

" move in virtual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap <leader><space> :noh<cr>

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

" view registers before paste
nnoremap <silent> <leader>p :<C-U>reg <bar> exec 'normal! "'.input('>').'P'<CR>

" terminal
:tnoremap <C-W>h <C-\><C-N><C-w>h
:tnoremap <C-W>j <C-\><C-N><C-w>j
:tnoremap <C-W>k <C-\><C-N><C-w>k
:tnoremap <C-W>l <C-\><C-N><C-w>l
:tnoremap <C-W>w <C-\><C-N><C-w>w

" }}}

" FUNCTIONS & COMMANDS {{{
" DiffOrig command to see the difference between the current buffer and the file it was loaded from.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

function! QuickFix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction

nnoremap <silent> <leader>q :call QuickFix_toggle()<cr>

" }}}
