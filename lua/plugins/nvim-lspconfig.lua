-- LSP Support
return {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
        -- LSP Management
        -- https://github.com/williamboman/mason.nvim
        { 'williamboman/mason.nvim' },
        -- https://github.com/williamboman/mason-lspconfig.nvim
        { 'williamboman/mason-lspconfig.nvim' },

        -- Auto-Install LSPs, linters, formatters, debuggers
        -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

        -- Useful status updates for LSP
        -- https://github.com/j-hui/fidget.nvim
        { 'j-hui/fidget.nvim',                        opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
        -- https://github.com/folke/neodev.nvim
        { 'folke/neodev.nvim',                        opts = {} }
    },
    config = function()
        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_attach = function(client, bufnr)
            -- Create your keybindings here...
            local status_ok, navic = pcall(require, "nvim-navic")
            if status_ok then
                -- Solo adjuntar navic si el servidor soporta símbolos de documento
                -- Y evitamos que se adjunte a gradle_ls si groovyls ya está ahí
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        end

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'bashls', 'cssls', 'html', 'gradle_ls', 'groovyls', 'lua_ls',
                'jsonls', 'lemminx', 'marksman', 'quick_lint_js',
                'yamlls', 'dockerls'
            },
            automatic_instalation = {
                exclude = { "jdtls" }
            },
            handlers = {
                -- Default handler for all servers not listed below
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities
                    })
                end,
                -- jdtls is handled exclusively by ftplugin/java.lua
                -- ['jdtls'] = function() end,
                ['yamlls'] = function()
                    lspconfig['yamlls'].setup({
                        capabilities = {
                            textDocument = {
                                foldingRange = {
                                    dynamicRegistration = false,
                                    lineFoldingOnly = true,
                                },
                            },
                        },
                        before_init = function(_, new_config)
                            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                                "force",
                                new_config.settings.yaml.schemas or {},
                                require("schemastore").yaml.schemas()
                            )
                        end,
                        settings = {
                            redhat = { telemetry = { enabled = false } },
                            yaml = {
                                keyOrdering = false,
                                format = { enable = true },
                                validate = true,
                                schemaStore = {
                                    enable = false,
                                    url = "",
                                },
                            },
                        },
                    })
                end,
                ['jsonls'] = function()
                    lspconfig['jsonls'].setup({
                        before_init = function(_, new_config)
                            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                        end,
                        settings = {
                            json = {
                                format = { enable = true },
                                validate = { enable = true },
                            },
                        },
                    })
                end,
                ['marksman'] = function()
                    lspconfig['marksman'].setup({})
                end,
                ['dockerls'] = function()
                    lspconfig['dockerls'].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                        settings = {
                            docker = {
                                languageserver = {
                                    formatter = {
                                        ignoreMultilineInstructions = true,
                                    },
                                },
                            }
                        }
                    })
                end,
            }
        })

        require('mason-tool-installer').setup({

            ensure_installed = {
                -- Java
                'jdtls',
                'java-debug-adapter',
                'java-test',
                'google-java-format',
                -- LSPs
                'bashls',
                'cssls',
                'html',
                'gradle_ls',
                'groovyls',
                'lua_ls',
                'jsonls',
                'lemminx',
                'marksman',
                'quick_lint_js',
                'yamlls',
                -- Extras
                'hadolint',
                'markdownlint-cli2',
                'markdown-toc',
                'npm-groovy-lint',
                'docker-language-server',
            }

        })
        -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
        -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
        vim.api.nvim_command('MasonToolsInstall')

        -- Lua LSP settings
        vim.lsp.config('lua_ls', {
            settings = {
                ['lua_ls'] = {
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' }
                    }
                }
            }
        })

        -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
        local open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded" -- Set border to rounded
            return open_floating_preview(contents, syntax, opts, ...)
        end
    end
}
