require('bqf').setup({
    magic_window = true,
    auto_resize_height = true,
    preview = {
        auto_preview = false,
        border = 'rounded',
        show_title = false,
        show_scroll_bar = false,
        winblend = 0,
        buf_label = true,
    },
    func_map = {
        open = 'o',
        openc = '<CR>'
    }
})
