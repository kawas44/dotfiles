local cmp = require('cmp')

local cmp_buffer_opts = {
    get_bufnrs = function()
        local buf = vim.api.nvim_get_current_buf() -- current buffer
        local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
        if byte_size > 1024 * 1024 then -- max 1 Mb
            return {}
        end
        return { buf }
    end
}

local cmp_path_opts = {
    get_cwd = function(_) return vim.fn.getcwd() end
}

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    completion = {
    },
    formatting = {
        format = function (entry, item)
            item.menu = '[' .. entry.source.name .. ']'
            return item
        end
    },
    sources = cmp.config.sources({
        { name = 'buffer', keyword_length = 3, option = cmp_buffer_opts },
        { name = 'vsnip' },
        { name = 'path', option = cmp_path_opts },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('clojure', {
    sources = cmp.config.sources({
        { name = 'iced', keyword_length = 3 },
        { name = 'tags', keyword_length = 3, keyword_pattern = [[[a-zA-Z0-9?*!+=<>-]\+]] },
        { name = 'buffer', keyword_length = 3, option = cmp_buffer_opts },
        { name = 'vsnip', keyword_length = 2, keyword_pattern =[[\k\+]] },
        { name = 'path', option = cmp_path_opts },
    })
})
