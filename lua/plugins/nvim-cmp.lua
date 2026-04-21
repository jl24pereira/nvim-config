return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/nvim-cmp",
        "onsails/lspkind.nvim", "saadparwaiz1/cmp_luasnip",
        { "L3MON4D3/LuaSnip", version = "v2.*" }, "rafamadriz/friendly-snippets"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require('lspkind')

        require("luasnip.loaders.from_lua").lazy_load({
            paths = { "~/.config/nvim/lua/plugins/snippets/" }
        })

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                    -- vim.snippet.expand(args.body)
                end
            },
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = {
                completion = {
                    border = "rounded", -- Fuerza el estilo de borde (rounded, single, double, solid)
                    winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    scrollbar = false
                },
                documentation = {
                    border = "rounded", -- Borde redondeado también para la ventana de documentación
                    winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"
                }
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
                ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),    -- scroll backward
                ['<C-f>'] = cmp.mapping.scroll_docs(4),     -- scroll forward
                ['<C-Space>'] = cmp.mapping.complete {},    -- show completion suggestions
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                },
                -- Tab through suggestions or when a snippet is active, tab to the next argument
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                -- Tab backwards through suggestions or when a snippet is active, tab to the next argument
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' })
            },
            -- Agrupamos sources para que aparezcan simultáneamente
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- lsp
                { name = "luasnip" }, -- snippets
                { name = "buffer" }, -- text within current buffer
                { name = "path" }    -- file system paths
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

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = 'buffer' } }
        })
    end
}
