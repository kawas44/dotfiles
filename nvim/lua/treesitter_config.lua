require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'lua', 'vim', 'help',
        'markdown', 'json', 'bash',
        'clojure' },
    highlight = {
        enable = true,
        disable = {},
    },
    incremental_selection = {
        enable = false,
        disable = {},
        keymaps = {
            init_selection = 'gnn',
            node_decremental = 'grm',
            node_incremental = 'grn',
            scope_incremental = 'grc',
        },
    },
    indent = {
        enable = false,
        disable = {},
    },
    matchup = {
        enable = false,
        disable = {},
    },
})
