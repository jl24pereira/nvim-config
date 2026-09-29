return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "b0o/SchemaStore.nvim",
        { "j-hui/fidget.nvim",  opts = {} },
        { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- reemplaza a neodev (deprecado)
    },
    config = function()
        -- ─────────────────────────────────────────────────────────────
        -- 1. CONFIGURACIÓN COMÚN PARA TODOS LOS SERVIDORES
        -- ─────────────────────────────────────────────────────────────
        vim.lsp.config("*", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })

        -- Breadcrumbs (barbecue/navic) para cualquier servidor, incluido jdtls
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local ok, navic = pcall(require, "nvim-navic")
                if ok and client
                    and client.server_capabilities.documentSymbolProvider
                    and not vim.b[args.buf].navic_client_id then
                    navic.attach(client, args.buf)
                end
            end,
        })

        -- ─────────────────────────────────────────────────────────────
        -- 2. AJUSTES POR SERVIDOR
        -- ─────────────────────────────────────────────────────────────
        vim.lsp.config("lua_ls", {
            settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        })

        vim.lsp.config("yamlls", {
            capabilities = {
                textDocument = {
                    foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
                },
            },
            settings = {
                redhat = { telemetry = { enabled = false } },
                yaml = {
                    keyOrdering = false,
                    format = { enable = true },
                    validate = true,
                    schemaStore = { enable = false, url = "" },
                    schemas = require("schemastore").yaml.schemas(),
                },
            },
        })

        vim.lsp.config("jsonls", {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    format = { enable = true },
                    validate = { enable = true },
                },
            },
        })

        vim.lsp.config("dockerls", {
            settings = {
                docker = {
                    languageserver = {
                        formatter = { ignoreMultilineInstructions = true },
                    },
                },
            },
        })

        -- ─────────────────────────────────────────────────────────────
        -- 3. INSTALAR Y ACTIVAR SERVIDORES
        -- ─────────────────────────────────────────────────────────────
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls", "cssls", "html", "groovyls", "lua_ls",
                "jsonls", "lemminx", "marksman", "quick_lint_js",
                "yamlls", "dockerls",
            },
            -- jdtls lo arranca ftplugin/java.lua, así que Mason NO debe activarlo
            automatic_enable = { exclude = { "jdtls" } },
        })

        -- Herramientas que no son servidores LSP de mason-lspconfig
        require("mason-tool-installer").setup({
            ensure_installed = {
                "tree-sitter-cli",
                -- Java (los usa ftplugin/java.lua)
                "jdtls",
                "java-debug-adapter",
                "java-test",
                "google-java-format",
                "vscode-spring-boot-tools",
                -- Linters y formateadores
                "hadolint",
                "markdownlint-cli2",
                "markdown-toc",
                "npm-groovy-lint",
                "prettier",
            },
        })

        -- Bordes redondeados en las ventanas flotantes del LSP
        local open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"
            return open_floating_preview(contents, syntax, opts, ...)
        end
    end,
}
