return {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("toggleterm").setup({
            -- Tamaño del split horizontal
            size = 15,

            -- Abrir siempre como split horizontal abajo
            direction = "horizontal",

            -- No crear tabs
            open_mapping = nil,

            -- Estilo visual
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            close_on_exit = true,

            -- Shell por defecto
            shell = vim.o.shell,

            -- Borde del float (por si en algún momento quieres flotante)
            float_opts = {
                border = "rounded",
                winblend = 10,
            },

            -- No mostrar número de línea en la terminal
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_option(term.bufnr, "filetype", "toggleterm")
            end,

            on_close = function()
                vim.cmd("stopinsert")
            end,
        })

        local Terminal     = require("toggleterm.terminal").Terminal

        -- ─────────────────────────────────────────────────────────────
        -- TERMINAL GENERAL (toggle con <leader>tt)
        -- ─────────────────────────────────────────────────────────────
        local general_term = Terminal:new({
            id        = 1,
            direction = "horizontal",
            size      = 15,
            on_open   = function(term)
                vim.cmd("startinsert!")
            end,
        })

        -- ─────────────────────────────────────────────────────────────
        -- GRADLE: bootRun (<leader>gr)
        -- ─────────────────────────────────────────────────────────────
        local gradle_run   = Terminal:new({
            id            = 2,
            cmd           = "./gradlew bootRun",
            direction     = "horizontal",
            size          = 20,
            close_on_exit = false, -- Mantener abierta para ver logs
            on_open       = function(term)
                vim.cmd("startinsert!")
            end,
        })

        -- ─────────────────────────────────────────────────────────────
        -- GRADLE: test (<leader>gT)
        -- ─────────────────────────────────────────────────────────────
        local gradle_test  = Terminal:new({
            id            = 3,
            cmd           = "./gradlew test",
            direction     = "horizontal",
            size          = 20,
            close_on_exit = false, -- Mantener abierta para ver resultado
            on_open       = function(term)
                vim.cmd("startinsert!")
            end,
        })

        -- ─────────────────────────────────────────────────────────────
        -- KEYMAPS
        -- ─────────────────────────────────────────────────────────────
        local keymap       = vim.keymap.set
        local opts         = { noremap = true, silent = true }

        -- Terminal general
        keymap("n", "<leader>tt", function()
            general_term:toggle()
        end, vim.tbl_extend("force", opts, { desc = "Terminal: Toggle" }))

        -- Gradle bootRun
        keymap("n", "<leader>gr", function()
            gradle_run:toggle()
        end, vim.tbl_extend("force", opts, { desc = "Gradle: bootRun" }))

        -- Gradle test
        keymap("n", "<leader>gT", function()
            gradle_test:toggle()
        end, vim.tbl_extend("force", opts, { desc = "Gradle: test" }))

        -- Gradle build
        keymap("n", "<leader>gB", function()
            Terminal:new({
                cmd           = "./gradlew clean build",
                direction     = "horizontal",
                size          = 20,
                close_on_exit = false,
            }):toggle()
        end, vim.tbl_extend("force", opts, { desc = "Gradle: clean & build" }))

        -- Gradle clean
        keymap("n", "<leader>gC", function()
            Terminal:new({
                cmd           = "./gradlew clean",
                direction     = "horizontal",
                size          = 20,
                close_on_exit = false,
            }):toggle()
        end, vim.tbl_extend("force", opts, { desc = "Gradle: clean" }))


        -- Salir del modo terminal con Esc (volver a modo normal)
        keymap("t", "<Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Terminal: modo normal" }))

        -- Navegar desde la terminal a otros splits sin cerrarla
        keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
        keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
        keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
        keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
    end,
}
