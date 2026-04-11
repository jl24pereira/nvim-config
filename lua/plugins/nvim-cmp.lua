return {
    "hrsh7th/nvim-cmp",
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip",
                    "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"},
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()

        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        -- Definimos la plantilla secreta "jdoc" exclusivamente para Java
        ls.add_snippets("java", {s("jdoc",
            {t({"/**", " * "}), i(1, "Descripción del método..."), t({"", " * @param "}), i(2, "nombre"),
             t({"", " * @return "}), i(3, "resultado"), t({"", " */"})})})

        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({
                    select = true
                }),
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item()
            }),
            sources = cmp.config.sources({{
                name = 'luasnip',
                priority = 1000
            }, {
                name = 'nvim_lsp',
                priority = 750
            }}, {{
                name = 'buffer'
            }})
        })
    end
}
