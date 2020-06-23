" Custom configuration for clojure buffers


" vim-fireplace
nnoremap <buffer> <F3> :Require<cr>

" fix indent of file
nnoremap <buffer> <F2> gg=G''

" asyncomplete
let g:asyncomplete_triggers['clojure'] = [ '/' ]

" ale linters
let b:ale_linters = {'clojure': ['clj-kondo']}
