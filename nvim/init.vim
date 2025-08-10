" My nvim config

set encoding=utf-8
language en_US.UTF-8

let mapleader = " "
let maplocalleader = "\\"

set termguicolors
set colorcolumn=80,100,120
set background=light
colorscheme default

" PLUGINS {{{
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

call plug#begin('~/.local/share/nvim/plugged')

    " basic edit
    Plug 'tpope/vim-repeat'
    Plug 'andymass/vim-matchup'
    Plug 'machakann/vim-sandwich'
    Plug 'echasnovski/mini.pairs'
    Plug 'mbbill/undotree', { 'on': ['UndotreeShow', 'UndotreeToggle'] }
    Plug 'psliwka/vim-smoothie'
    Plug 'will133/vim-dirdiff'

    " quickfix
    Plug 'romainl/vim-qf'
    Plug 'kevinhwang91/nvim-bqf'

    " buffers, files & terminal
    Plug 'tpope/vim-eunuch'
    Plug 'kshenoy/vim-signature'
    Plug 'voldikss/vim-floaterm', {
                \ 'on': ['FloatermNew', 'FloatermToggle', 'FloatermKill'] }

    " search & navigate
    Plug 'asiryk/auto-hlsearch.nvim'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'justinmk/vim-sneak', { 'on': ['<Plug>Sneak_s', '<Plug>Sneak_S'] }
    Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] }
    Plug 'kwkarlwang/bufjump.nvim'

    " fuzzy stuff
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " code & vcs
    Plug 'tpope/vim-commentary'
    Plug 'itchyny/vim-gitbranch'
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog', {'on': ['Flog']}
    Plug 'airblade/vim-gitgutter'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground', {
                \ 'on': ['TSHighlightCapturesUnderCursor', 'TSNodeUnderCursor']}

    Plug 'nvim-lua/plenary.nvim'
    Plug 'sindrets/diffview.nvim'

    " completion
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'quangnguyen30192/cmp-nvim-tags'

    " snippet
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-vsnip'

    " linting
    Plug 'dense-analysis/ale'

    " generic repl
    Plug 'urbainvaes/vim-ripple'

    " languages with parenthesis
    Plug 'guns/vim-sexp', { 'for': ['clojure', 'scheme', 'fennel'] }
    Plug 'tpope/vim-sexp-mappings-for-regular-people', {
                \'for': ['clojure', 'scheme', 'fennel'] }

    " fennel
    Plug 'jaawerth/fennel.vim'

    " clojure
    Plug 'clojure-vim/clojure.vim'
    Plug 'liquidz/vim-iced', { 'for': 'clojure' }
    Plug 'lamp/cmp-iced'

    " others
    Plug 'diepm/vim-rest-console', { 'for': 'rest' }
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase', 'on': ['HexokinaseToggle'] }

    " icons & colors
    Plug 'wincent/base16-nvim'
    Plug 'ramojus/mellifluous.nvim'
    Plug 'sainnhe/gruvbox-material'
    Plug 'EdenEast/nightfox.nvim'

    Plug 'mstcl/dmg'
    Plug 'ntk148v/komau.vim'
    Plug 'yorickpeterse/vim-paper'
    Plug 'miikanissi/modus-themes.nvim'

    Plug 'axgfn/parchment'
    Plug 'plan9-for-vimspace/acme-colors'
    Plug 'cideM/yui'

    Plug 'zenbones-theme/zenbones.nvim'
    Plug 'rktjmp/lush.nvim'

    Plug 'byounghoonkim/random-colorscheme.nvim'

call plug#end()

let g:gruvbox_material_background = 'soft'
let g:komau_italic=0

lua << EOF
require("modus-themes").setup({
        style = "auto",
        variant = "tinted",
        dim_inactive = false,
})
EOF

lua << EOF
require('random-colorscheme').setup({
    random_on_startup = true,
    colorschemes = {
        "dmg",
        "komau",
        "paper",
        "modus_operandi",
        "parchment",
        "acme",
        "yui",
        "seoulbones",
        "zenbones",
        "vimbones",
        "forestbones",
        "tokyobones",
        "neobones",
        "zenwritten",
        "rosebones",
    },
    show_current = false,
})
EOF

" matchup
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_delim_stopline = 10000

" sandwich
runtime macros/sandwich/keymap/surround.vim

" mini.pairs
lua require('mini.pairs').setup()

" undotree
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

" qf
let g:qf_window_bottom = 0
let g:qf_auto_resize = 0

nmap <Leader>qs <Plug>(qf_qf_switch)
nmap <Leader>qt <Plug>(qf_qf_toggle)

" bqf
lua require('bqf_config')

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

" auto-hlsearch
lua require('auto-hlsearch').setup()

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

" bufjump
lua require('bufjump').setup({ forward_key = ']j', backward_key = '[j' })

" fzf
let $FZF_DEFAULT_COMMAND = 'fd -t f -c never'
let g:fzf_preview_window = ''
let g:fzf_layout = { 'window': 'enew' }

nnoremap <Leader>o <Cmd>Files<CR>

" fugitive & flog
augroup Set_Git_Mapping
    autocmd!
    autocmd BufEnter * if finddir('.git', expand('%:p:h') . ';') != ''
        \ | nnoremap <silent> <buffer> <F7> <Cmd>Gtabedit :<CR>
        \ | nnoremap <silent> <buffer> <F8> <Cmd>Flog -all -date=short<CR>
        \ | nnoremap <silent> <buffer> <F9> <Cmd>DiffviewOpen<CR>
        \ | endif

    autocmd User FugitiveIndex normal gU
    autocmd User FugitiveCommit setlocal foldmethod=syntax foldlevel=0
    autocmd WinEnter 'floggraph' :call flog#floggraph#buf#Update()

    autocmd BufEnter DiffviewFilePanel
        \ nnoremap <silent> <buffer> gq <Cmd>DiffviewClose<CR>
augroup END

" diffview
lua require('diffview').setup({use_icons = false})

" gutentags
let g:gutentags_ctags_exclude = ["target", "resources", "dev-resources", "test-resources", "tmp"]
let g:gutentags_ctags_extra_args = ["--languages=lua,clojure,python,go,java"]

" treesitter
lua require('treesitter_config')

" cmp
lua require('cmp_config')

" vsnip
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

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

" ripple
let g:ripple_repls = {}
let g:ripple_repls['scheme.guile'] = { "command": "guile3.0 -L ." }
let g:ripple_repls['fennel'] = { "command": "fennel" }

" sexp
let g:sexp_filetypes = 'clojure,scheme,lisp,scheme.guile,timl,fennel'

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
let g:iced_formatter = 'default'
let g:iced#format#rule = {
            \ 'go-try': '[[:block 0]]',
            \ 'go-ctx': '[[:block 0]]',
            \ 'when-ch': '[[:block 1]]',
            \ 'when-xt': '[[:block 1]]',
            \ 'defrecord': '[[:inner 1]]',
            \ }
"    disable sexp format
let g:sexp_mappings = {'sexp_indent': '', 'sexp_indent_top': ''}
let g:sexp_enable_insert_mode_mappings = 0

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
    set directory=~/.local/share/nvim/swap//,.
    set backupdir=~/.local/share/nvim/backup//,.
    set undodir=~/.local/share/nvim/undo//,.
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
set noequalalways

set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram
set jumpoptions+=stack

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

" quick save
nnoremap <C-S> <Cmd>update<CR>
inoremap <C-S> <Cmd>update<CR>
nnoremap gq <Cmd>close<CR>

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
augroup Term_Insert
    autocmd!
    autocmd TermOpen,BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END

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
    let head = gitbranch#name()
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
