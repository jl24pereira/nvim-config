return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
        -- Modo de apertura por defecto
        auto_close    = false,  -- No cerrar automáticamente cuando no hay problemas
        auto_open     = false,  -- No abrir automáticamente al haber errores
        auto_preview  = true,   -- Preview del archivo al navegar en el panel
        auto_fold     = false,  -- No colapsar grupos automáticamente
        auto_jump     = {},     -- No saltar automáticamente (control manual)
        focus         = true,   -- Enfocar el panel al abrirlo

        -- Íconos de tipo de diagnóstico
        icons         = {
            error       = " ",
            warning     = " ",
            hint        = " ",
            information = " ",
            other       = " ",
        },

        -- Agrupación por archivo
        group         = true,

        -- Padding en el panel
        padding       = true,

        -- Ciclo al llegar al último/primer item
        cycle_results = true,

        -- Modo de apertura del panel
        position      = "bottom",
        height        = 12,

        -- Qué mostrar en cada modo
        modes         = {
            -- Diagnósticos del workspace completo (todos los archivos)
            lsp_workspace = {
                auto_open = false,
            },
        },
    },
    keys = {
        -- Diagnósticos del workspace (todos los archivos del proyecto)
        {
            "<leader>lx",
            "<cmd>Trouble diagnostics toggle<CR>",
            desc = "Trouble: Diagnósticos del proyecto",
        },
        -- Diagnósticos solo del buffer actual
        {
            "<leader>lb",
            "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
            desc = "Trouble: Diagnósticos del buffer",
        },
        -- Símbolos del archivo actual (clases, métodos, variables)
        {
            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<CR>",
            desc = "Trouble: Símbolos del archivo",
        },
        -- Referencias LSP (reemplaza gr nativa)
        {
            "<leader>lr",
            "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
            desc = "Trouble: Referencias LSP",
        },
        -- Quickfix list en Trouble
        {
            "<leader>lq",
            "<cmd>Trouble qflist toggle<CR>",
            desc = "Trouble: Quickfix list",
        },
        -- Location list en Trouble
        {
            "<leader>ll",
            "<cmd>Trouble loclist toggle<CR>",
            desc = "Trouble: Location list",
        },
        -- Navegar al siguiente diagnóstico (sin abrir el panel)
        {
            "[x",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
            desc = "Trouble: Siguiente problema",
        },
        -- Navegar al diagnóstico anterior (sin abrir el panel)
        {
            "]x",
            function()
                require("trouble").prev({ skip_groups = true, jump = true })
            end,
            desc = "Trouble: Problema anterior",
        },
    },
}
