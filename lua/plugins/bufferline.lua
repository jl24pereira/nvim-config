return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
            require("bufferline").setup({
                options = {
                    offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer", 
                        text_align = "center",
                        separator = true,
                    }
                },
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = false,
                show_close_icon = false,
                }
            })
        end,
}
