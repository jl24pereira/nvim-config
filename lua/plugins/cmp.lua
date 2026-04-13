return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/nvim-cmp", "saadparwaiz1/cmp_luasnip",
        {"L3MON4D3/LuaSnip", version = "v2.*"}, "rafamadriz/friendly-snippets"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        require("luasnip.loaders.from_lua").lazy_load({
            paths = {"~/AppData/Local/nvim/lua/plugins/snippets/"}
        })

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                    -- vim.snippet.expand(args.body)
                end
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            -- Agrupamos sources para que aparezcan simultáneamente
            sources = cmp.config.sources({
                {name = 'nvim_lsp'}, {name = 'luasnip'}
            }),
            cmp.setup.cmdline({'/', '?'}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {{name = 'buffer'}}
            })

        })
    end
}
