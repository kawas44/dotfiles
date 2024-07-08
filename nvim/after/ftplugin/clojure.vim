" Custom configuration for clojure buffers

" ale linters
let b:ale_linters = {'clojure': ['clj-kondo']}

" iced
nnoremap <F3> <Cmd>IcedRequire<CR>
nnoremap <F2> <Cmd>IcedCleanAll<CR>

nmap <LocalLeader>ere <Plug>(iced_eval_and_replace)<Plug>(sexp_outer_list)``
nmap <LocalLeader>ert <Plug>(iced_eval_and_replace)<Plug>(sexp_outer_top_list)``

nmap <LocalLeader>ece <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_list)``
nmap <LocalLeader>ect <Plug>(iced_eval_and_comment)<Plug>(sexp_outer_top_list)``

nmap <LocalLeader>eTe <Plug>(iced_eval_and_tap)<Plug>(sexp_outer_list)``
nmap <LocalLeader>eTt <Plug>(iced_eval_and_tap)<Plug>(sexp_outer_top_list)``

" tree-sitter highlight
highlight! default link @function.builtin Identifier
highlight! default link @constant.builtin @boolean
highlight! default link @variable @text
highlight! default link @function @text
highlight! default link @keyword.operator @function.macro
highlight! default link @operator @function.macro

highlight! default link @constructor @text
highlight! default link @field @text
highlight! default link @method @text
