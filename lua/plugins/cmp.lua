return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/nvim-cmp",
        "onsails/lspkind.nvim", "saadparwaiz1/cmp_luasnip",
        {"L3MON4D3/LuaSnip", version = "v2.*"}, "rafamadriz/friendly-snippets"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require('lspkind')

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
                completion = {
                    border = "rounded", -- Fuerza el estilo de borde (rounded, single, double, solid)
                    winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    scrollbar = false,
                },
                documentation = {
                    border = "rounded", -- Borde redondeado también para la ventana de documentación
                    winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                }
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
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    maxwidth = 50,
                    ellipsis_char = '...',
                    menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]"
                    })
                })
            }
        })

        cmp.setup.cmdline({'/', '?'}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = 'buffer'}}
        })
    end
}
