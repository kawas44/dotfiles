" Custom configuration for clojure buffers


" vim-fireplace
nnoremap <buffer> <F3> :Require<cr>

" fix indent of file
nnoremap <buffer> <F2> gg=G''

" deoplete clojure
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})

" ale linters
let b:ale_linters = {'clojure': ['clj-kondo']}

" Do not lint or fix project.clj or profiles.clj
let g:ale_pattern_options = {
\ 'project\.clj$': {'ale_linters': [], 'ale_fixers': []},
\ 'profiles\.clj$': {'ale_linters': [], 'ale_fixers': []},
\}
