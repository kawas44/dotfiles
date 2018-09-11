" Custom configuration for clojure buffers


" vim-clojure-static
" break things for the moment setlocal iskeyword-=/

" vimcompletesme
let b:vcm_omni_pattern = '\(\k\+\.\|\k\+\/\)\?\k*$'
let b:vcm_tab_complete = "omni"

" vim-fireplace
nnoremap <buffer> <F3> :Require<cr>
