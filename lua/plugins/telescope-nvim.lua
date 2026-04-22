return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'ahmedkhalf/project.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
        local telescope = require('telescope')
        local fb_actions = telescope.extensions.file_browser.actions

        -- Configuración del Gestor de Proyectos
        require("project_nvim").setup({
            detection_methods = { "lsp", "pattern" },
            patterns = {
                "settings.gradle",
                "settings.gradle.kts",
                ".git",
                "mvnw",
                "gradlew",
                "pom.xml",
                -- "build.gradle"
            },
        })

        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    -- Compilados Java
                    "%.class",
                    "bin/",
                    "build/",
                    -- Control de versiones
                    "%.git/",
                    -- Gradle cache
                    "%.gradle/",
                    ".gradle/",
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--glob=!**/*.class", -- excluir .class del grep
                    "--glob=!**/bin/**",  -- excluir carpeta bin
                    "--glob=!**/build/**",
                },
            },
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                ["file_browser"] = {
                    -- theme = "ivy",
                    hijack_netrw = true, -- Reemplaza el explorador nativo
                    mappings = {
                        ["i"] = {
                            ["<A-s>"] = fb_actions.change_cwd,
                            ["<A-c>"] = fb_actions.create,
                            ["<A-r>"] = fb_actions.rename,
                            ["<A-m>"] = fb_actions.move,
                            ["<A-d>"] = fb_actions.remove,
                        },
                        ["n"] = {
                            -- Mismos comandos pero para el modo Normal de Telescope
                            ["s"] = fb_actions.change_cwd,
                            ["c"] = fb_actions.create,
                            ["r"] = fb_actions.rename,
                            ["m"] = fb_actions.move,
                            ["d"] = fb_actions.remove,
                        },
                    },
                },
            },
        })

        -- 🟢 Carga segura de extensiones (evita la pantalla roja)
        pcall(telescope.load_extension, "ui-select")
        pcall(telescope.load_extension, "projects")
        pcall(telescope.load_extension, "file_browser")
        pcall(telescope.load_extension, "dap")
    end
}
