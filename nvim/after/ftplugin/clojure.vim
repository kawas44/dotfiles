" Custom configuration for clojure buffers


" vim-fireplace
nnoremap <buffer> <F3> :Require<cr>

" fix indent of file
nnoremap <buffer> <F2> gg=G''

" deoplete clojure
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
