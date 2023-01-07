" Asyncomplete: Register Iced source
call asyncomplete#register_source({
      \ 'name': 'vim-iced',
      \ 'allowlist': ['clojure'],
      \ 'completor': function('iced#asyncomplete#complete'),
      \ })

" Ale: Disable lint on project file
let g:ale_pattern_options['project\.clj$'] = {
    \ 'ale_linters': [], 'ale_fixers': [] }
