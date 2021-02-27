" Custom configuration for clojure buffers

" ale linters
let b:ale_linters = {'clojure': ['clj-kondo']}

" fireplace
nnoremap  <F3> :Require<CR>
" ... indent file
nnoremap <buffer> <F2> gg=G''
