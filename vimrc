" My vim config

set nocompatible
set encoding=utf-8
scriptencoding utf-8
language en_US.UTF-8

let mapleader = " "
let maplocalleader = "\\"

" PLUGINS {{{
call plug#begin('~/.vim/plugged')

    " basic edit
    Plug 'tpope/vim-repeat'
    Plug 'andymass/vim-matchup'
    Plug 'machakann/vim-sandwich'
    Plug 'mbbill/undotree', { 'on': ['UndotreeShow', 'UndotreeToggle'] }
    Plug 'ConradIrwin/vim-bracketed-paste'

    " quickfix
    Plug 'romainl/vim-qf'
    Plug 'yssl/QFEnter'

    " buffers, files & terminal
    Plug 'tpope/vim-eunuch'
    Plug 'kshenoy/vim-signature'
    Plug 'voldikss/vim-floaterm', {
                \ 'on': ['FloatermNew', 'FloatermToggle', 'FloatermKill'] }

    " search & navigate
    Plug 'romainl/vim-cool'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'justinmk/vim-sneak', { 'on': ['<Plug>Sneak_s', '<Plug>Sneak_S'] }
    Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] }

    " fuzzy stuff
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " code & vcs
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog', {'on': ['Flog']}
    Plug 'airblade/vim-gitgutter'
    Plug 'ludovicchabant/vim-gutentags'

    " completion
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-buffer.vim'

    " linting
    Plug 'dense-analysis/ale'

    " fennel
    Plug 'jaawerth/fennel.vim'

    " clojure
    Plug 'clojure-vim/clojure.vim'
    Plug 'guns/vim-sexp', { 'for': ['clojure', 'fennel'] }
    Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': ['clojure', 'fennel'] }

    Plug 'liquidz/vim-iced', { 'for': 'clojure' }
    Plug 'liquidz/vim-iced-asyncomplete', { 'for': 'clojure' }

    " others
    Plug 'diepm/vim-rest-console', { 'for': 'rest' }
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase', 'on': ['HexokinaseToggle'] }

    " icons & colors
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'conweller/endarkened.vim'
    Plug 'kjssad/quantum.vim'
    Plug 'lifepillar/vim-gruvbox8'
    Plug 'lifepillar/vim-solarized8'
    Plug 'sainnhe/gruvbox-material'
    Plug 'zefei/cake16'
    Plug 'zheng7/stellarized'

call plug#end()

" matchup
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_delim_stopline = 10000

" sandwich
runtime macros/sandwich/keymap/surround.vim

" undotree
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

" qf
nmap <Leader>qs <Plug>(qf_qf_switch)
nmap <Leader>qt <Plug>(qf_qf_toggle)

" qfenter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" floaterm
let g:floaterm_opener = 'edit'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9

nnoremap <F5> <Cmd>FloatermToggle aTerm<CR>
tnoremap <F5> <Cmd>FloatermToggle aTerm<CR>
nnoremap <F4> <Cmd>FloatermNew --disposable vifm<CR>
tnoremap <F4> <Cmd>FloatermHide<CR>

augroup Quit_Floaterm
    autocmd!
    autocmd QuitPre * FloatermKill!
augroup END

" sneak
let g:sneak#label = 1

nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S

" grepper
let g:grepper = {}
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.dir = 'repo,filecwd'
let g:grepper.prompt_quote = 2
let g:grepper.operator = {}
let g:grepper.operator.prompt = 1

nnoremap <Leader>g <Cmd>Grepper<CR>
nmap gr <Plug>(GrepperOperator)
xmap gr <Plug>(GrepperOperator)

" fzf
let $FZF_DEFAULT_COMMAND = 'fd -t f -c never'
let g:fzf_preview_window = ''
let g:fzf_layout = { 'window': 'enew' }

nnoremap <Leader>o <Cmd>Files<CR>

" fugitive & flog
augroup Set_Git_Mapping
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != ''
        \ | nnoremap <silent> <buffer> <F7> <Cmd>Git<CR>
        \ | nnoremap <silent> <buffer> <F8> <Cmd>Flog -all -date=short<CR>
        \ | endif

    autocmd User FugitiveIndex normal gU
    autocmd User FugitiveCommit setlocal foldmethod=syntax foldlevel=0
    autocmd WinEnter * if (&ft == 'floggraph')
        \ | :call flog#floggraph#buf#Update()
        \ | endif
augroup END

" gutentags
let g:gutentags_ctags_exclude = ["target", "resources", "tmp"]

" asyncomplete
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_min_chars = 1
imap <C-Space> <Plug>(asyncomplete_force_refresh)

call asyncomplete#register_source(
    \ asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': [],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_info_str = 'I'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] %(code): %%s [%linter%]'

let g:ale_pattern_options = {}

nmap <silent> [l <Plug>(ale_previous_wrap)
nmap <silent> ]l <Plug>(ale_next_wrap)

" clojure-static
let g:clojure_maxlines = 1000
let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1  "yuk
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^cond']

" iced
let g:iced_enable_default_key_mappings = v:true
let g:iced_default_key_mapping_leader = '<LocalLeader>'
let g:iced_enable_auto_indent = v:false
let g:iced#nrepl#skip_evaluation_when_buffer_size_is_exceeded = v:true
let g:iced#notify#max_height_rate = 0.4
let g:iced#notify#max_width_rate = 0.4
"    disable sexp format
let g:sexp_mappings = {'sexp_indent': '', 'sexp_indent_top': ''}

" rest-console
let g:vrc_curl_opts = { '-sS': '', '-i': '' }
let g:vrc_output_buffer_name = '__VRC_REST.json'

" hexokinase
let g:Hexokinase_highlighters = [ 'backgroundfull' ]
let g:Hexokinase_optInPatterns = [ 'full_hex', 'triple_hex', 'rgb', 'hsl' ]

" }}}

" OPTIONS {{{
set hidden
set autoread
set autowrite
set updatetime=500

augroup Check_Changes
    autocmd!
    autocmd FocusGained,BufWinEnter,WinEnter * :checktime
augroup END

set nobackup
set writebackup
set undofile

if has("unix") || has("mac")
    set directory=~/.local/share/vim/swap//,.
    set backupdir=~/.local/share/vim/backup//,.
    set undodir=~/.local/share/vim/undo//,.
endif

set mouse=a
set timeout timeoutlen=1500 ttimeoutlen=100

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase
set incsearch
set nowrapscan
set hlsearch

set report=0
set shortmess=finotxFOT

set noruler
set showcmd
set laststatus=2
set showmode
set cmdheight=2
set nonumber
set signcolumn=yes
set nowrap
set list
set listchars=tab:»\ ,trail:·,nbsp:‗
set nocursorline
set scrolloff=5
set sidescrolloff=7

set foldmethod=marker
set foldlevelstart=1

set wildmenu
set wildmode=longest:full,full

set completeopt=menuone,noinsert,noselect

set spelllang=en_us
set complete+=kspell

set title
set statusline=%-.50(\ %f%m%r%w%)%=\ %{Stl_git()}%{Stl_buf()}%{%Stl_ruler()%}

set lazyredraw
set synmaxcol=3000

set splitbelow
set splitright
set equalalways

set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

set background=light
set termguicolors
set colorcolumn=80,100,120
colorscheme PaperColor

" fix kitty background glitch
if $TERM == "xterm-kitty"
    let &t_ut=''
endif

" fix alacritty termguicolors
if $TERM == "alacritty"
    set ttymouse=sgr
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

augroup Toggle_Cursorline
    autocmd!
    autocmd FocusGained,WinEnter * set cursorline
    autocmd FocusLost,WinLeave * set nocursorline
augroup END

augroup Set_FormatOptions
    autocmd!
    autocmd BufEnter * set formatoptions-=ro
    autocmd BufEnter * setlocal formatoptions-=ro
augroup END

" Numbers inc/dec
set nrformats-=octal

" Deal with special edits
set backspace=indent,eol,start

" }}}

" MAPPINGS {{{
" disable ex mode shortcut key
nnoremap Q <Nop>
nnoremap U <Nop>

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

nnoremap <Leader><Space> <Cmd>noh<CR>

" use very magic
nnoremap / /\v
xnoremap / /\v

nnoremap ? ?\v
xnoremap ? ?\v

" easier exact location mark jump
nnoremap ' `
nnoremap ` '

" repeat substitution keeping flags
nnoremap & <Cmd>&&<CR>
xnoremap & <Cmd>&&<CR>

" unimpaired like
nnoremap [b <Cmd>bprevious<CR>
nnoremap ]b <Cmd>bnext<CR>
nnoremap [B <Cmd>bfirst<CR>
nnoremap ]B <Cmd>blast<CR>

nnoremap [t <Cmd>tabprevious<CR>
nnoremap ]t <Cmd>tabnext<CR>
nnoremap [T <Cmd>tabfirst<CR>
nnoremap ]T <Cmd>tablast<CR>

nnoremap [q <Cmd>cprevious<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap [Q <Cmd>cfirst<CR>
nnoremap ]Q <Cmd>clast<CR>

" spelling
nnoremap <Leader>k <Cmd>set spell!<Bar>set spell?<CR>

" add undo break-points
inoremap , ,<C-G>u
inoremap . .<C-G>u
inoremap ; ;<C-G>u

" view registers before paste
nnoremap <silent> <Leader>p <Cmd>reg<Bar>exec 'normal! "'.input('>').'P'<CR>

" terminal
tnoremap <C-N> <C-\><C-N>

tnoremap <C-W>h <Cmd>wincmd h<CR>
tnoremap <C-W>j <Cmd>wincmd j<CR>
tnoremap <C-W>k <Cmd>wincmd k<CR>
tnoremap <C-W>l <Cmd>wincmd l<CR>
tnoremap <C-W>w <Cmd>wincmd w<CR>

tnoremap <C-W><C-h> <Cmd>wincmd h<CR>
tnoremap <C-W><C-j> <Cmd>wincmd j<CR>
tnoremap <C-W><C-k> <Cmd>wincmd k<CR>
tnoremap <C-W><C-l> <Cmd>wincmd l<CR>
tnoremap <C-W><C-w> <Cmd>wincmd w<CR>

" }}}

" FUNCTIONS & COMMANDS {{{

function! Stl_git() abort
    let head = fugitive#Head()
    if head ==# ''
        return ''
    endif
    return '  ' . head . '  '
endfunction

function! Stl_buf() abort
    let fi = ''

    if &ft !=# ''
        let fi .= ' ' . get(g:ft_icons, &ft, '')
    endif

    if &ff ==# 'dos'
        let fi .= ' '
    else
        let fi .=  ' '
    endif

    if &fenc !=# ''
        let fi .= ' ' . &fenc
    endif

    return fi .  ' '
endfunction

function! Stl_ruler() abort
    return '%5l,%-3v%3p%% '
endfunction

let g:ft_icons = {
    \ 'clojure': '',
    \ 'go': '',
    \ 'groovy': '',
    \ 'java': '',
    \ 'javascript': '',
    \ 'jproperties': '',
    \ 'lua': '',
    \ 'markdown': '',
    \ 'python': '',
    \ 'rust': '',
    \ 'sh': '',
    \ 'vim': '',
    \ }

" }}}
