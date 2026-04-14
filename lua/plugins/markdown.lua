return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim',
            'nvim-mini/mini.icons', 'nvim-tree/nvim-web-devicons'
        },
        --- @module 'render-markdown'
        --- @type render.md.UserConfig
        opts = {file_type = {"markdown"}}
    }, {
        "iamcco/markdown-preview.nvim",
        cmd = {
            "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"
        },
        ft = {"markdown"},
        build = function() vim.fn["mkdp#util#install"]() end,
        keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    }, -- Configuración del LSP Marksman vía lspconfig
    {"neovim/nvim-lspconfig", opts = {servers = {marksman = {}}}}
}
