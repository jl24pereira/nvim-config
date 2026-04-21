return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
            untracked    = { text = "▎" },
        },
        signs_staged = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
        },

        -- Muestra el blame de la línea actual de forma inline (tenue)
        current_line_blame = false, -- Actívalo con <leader>gtb cuando lo necesites
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 800,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = " <author>, <author_time:%d/%m/%Y> · <summary>",

        -- Preview de hunks dentro del propio buffer
        preview_config = {
            border   = "rounded",
            style    = "minimal",
            relative = "cursor",
            row      = 0,
            col      = 1,
        },

        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- -----------------------------------------------------------------
            -- NAVEGACIÓN entre hunks
            -- -----------------------------------------------------------------
            map("n", "]g", function()
                if vim.wo.diff then return "]g" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, "Git: Siguiente hunk")

            map("n", "[g", function()
                if vim.wo.diff then return "[g" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, "Git: Hunk anterior")

            -- -----------------------------------------------------------------
            -- STAGE / UNSTAGE / RESET
            -- -----------------------------------------------------------------
            map("n", "<leader>ghs", gs.stage_hunk, "Git: Stage hunk")
            map("n", "<leader>ghr", gs.reset_hunk, "Git: Reset hunk")
            map("n", "<leader>ghS", gs.stage_buffer, "Git: Stage buffer completo")
            map("n", "<leader>ghR", gs.reset_buffer, "Git: Reset buffer completo")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Git: Deshacer stage hunk")

            -- Stage/reset en selección visual
            map("v", "<leader>ghs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Git: Stage selección")

            map("v", "<leader>ghr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Git: Reset selección")

            -- -----------------------------------------------------------------
            -- PREVIEW / DIFF / BLAME
            -- -----------------------------------------------------------------
            map("n", "<leader>ghp", gs.preview_hunk, "Git: Preview hunk")
            map("n", "<leader>ghd", gs.diffthis, "Git: Diff buffer vs index")
            map("n", "<leader>ghD", function() gs.diffthis("~") end, "Git: Diff vs último commit")
            map("n", "<leader>gtb", gs.toggle_current_line_blame, "Git: Toggle blame inline")
            map("n", "<leader>gtd", gs.toggle_deleted, "Git: Toggle líneas eliminadas")

            -- -----------------------------------------------------------------
            -- TEXT OBJECT: operar sobre el hunk completo con 'ih'
            -- Ejemplo: vih → selecciona el hunk | dih → elimina el hunk
            -- -----------------------------------------------------------------
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: Seleccionar hunk")
        end,
    },
}
