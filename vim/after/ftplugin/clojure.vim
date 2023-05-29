" Custom configuration for clojure buffers

" asyncomplete: Register Iced source
call asyncomplete#register_source({
      \ 'name': 'vim-iced',
      \ 'allowlist': ['clojure'],
      \ 'completor': function('iced#asyncomplete#complete'),
      \ })

" ale: Disable lint on project file
let g:ale_pattern_options['project\.clj$'] = {
    \ 'ale_linters': [], 'ale_fixers': [] }

" ale: prefered linter
let b:ale_linters = {'clojure': ['clj-kondo']}

" iced
nnoremap <F3> <Cmd>IcedRequire<CR>
nnoremap <F2> <Cmd>IcedFormatAll<CR>

nmap <LocalLeader>ere <Plug>(iced_eval_and_replace)<Plug>(sexp_outer_list)``
nmap <LocalLeader>ert <Plug>(iced_eval_and_replace)<Plug>(sexp_outer_top_list)``

nmap <LocalLeader>ece <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_list)``
nmap <LocalLeader>ect <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_top_list)``

nmap <LocalLeader>eae <Plug>(iced_eval_and_tap)<Plug>(sexp_outer_list)``
nmap <LocalLeader>eat <Plug>(iced_eval_and_tap)<Plug>(sexp_outer_top_list)``
