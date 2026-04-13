return {
    "neovim/nvim-lspconfig",
    -- Evento recomendado para no bloquear el inicio de Neovim
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"williamboman/mason-lspconfig.nvim"},
    config = function()
        local lspconfig = require("lspconfig")

        -- Obtenemos las capacidades de cmp.lua para que el LSP sepa comunicarse con el menú
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason-lspconfig").setup({
            ensure_installed = {"groovyls", "jdtls"},

            handlers = {
                -- 1. Handler por defecto (se aplica a cualquier servidor que no tenga configuración específica)
                function(server_name)
                    -- ¡REGLA DE ORO!: Ignoramos jdtls aquí para que el plugin especializado nvim-jdtls lo maneje después
                    if server_name ~= "jdtls" then
                        lspconfig[server_name].setup({
                            capabilities = capabilities
                        })
                    end
                end,

                -- 2. Configuración específica para los scripts de configuración
                ["groovyls"] = function()
                    lspconfig.groovyls.setup({
                        capabilities = capabilities,
                        filetypes = {"groovy", "gradle"},
                        -- Estrategia oficial para detectar la raíz de proyectos empresariales complejos
                        root_dir = lspconfig.util.root_pattern("settings.gradle", "build.gradle", ".git")
                    })
                end
            }
        })
    end
}
