return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        win = {
            no_overlap = false,
            padding = { 1, 2 },
            title = true,
            title_pos = "center",
            border = "rounded",
            col = 0.5,
            row = 0.5,
            wo = {
                winblend = 10,
            },
        },

        layout = {
            width = { min = 20 },
            spacing = 3,
            { "<leader>gt", group = "󰊢 Git Toggle" },
            spacing = 3,
        },

        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
            colors = true,
        },

        -- Grupos: organizan el popup de which-key por prefijo
        spec = {
            -- Archivos / Guardar
            { "<leader>w", group = "󰆓 Guardar / Salir" },
            -- Explorador
            { "<leader>e", group = "󰙅 Explorador" },
            -- Buscar (Telescope)
            { "<leader>f", group = " Buscar (Telescope)" },
            -- LSP / Navegación de código
            { "<leader>g", group = " LSP / Ir a..." },
            -- Java específico
            { "<leader>j", group = " Java" },
            { "<leader>jt", group = "󰙨 Tests (Neotest)" },
            -- Debug (DAP)
            { "<leader>d", group = " Debug (DAP)" },
            -- Breakpoints
            { "<leader>b", group = " Breakpoints" },
            -- Splits / Ventanas
            { "<leader>s", group = " Splits / Ventanas" },
            -- Tabs
            { "<leader>t", group = "󰓩 Tabs" },
            -- Quickfix
            { "<leader>q", group = " Quickfix" },
            -- Git
            { "<leader>gh", group = "󰊢 Git Hunks" },
            { "<leader>gt", group = "󰊢 Git Toggle" },
            { "<leader>gb", desc = "Git: Toggle Blame" },
            -- Diff / Merge (dentro de g por coherencia LSP/Git)
            { "<leader>c", group = " Diff / Merge" },
            -- Rename / Code actions (atajos rápidos sin prefijo largo)
            { "<leader>r", group = "󰑕 Refactor" },
            { "<leader>l", group = "󰒕 LSP Extra" },
            { "<leader>i", group = "󰆉 Insertar" },
            { "<leader>io", desc = " Insertar TODO comment" },
        },

    }

}
