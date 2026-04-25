return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("todo-comments").setup({
            signs = true,
            sign_priority = 8,

            keywords = {
                FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = " ", color = "info" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            },

            gui_style = {
                fg = "NONE",
                bg = "BOLD",
            },

            merge_keywords = false, -- usar SOLO los keywords definidos arriba

            highlight = {
                multiline         = true,
                multiline_pattern = "^.",
                multiline_context = 10,
                before            = "",
                keyword           = "wide",
                after             = "fg",
                pattern           = [[.*<(KEYWORDS)\s*:]],
                comments_only     = true,
                max_line_len      = 400,
                exclude           = {},
            },

            colors = {
                error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info    = { "DiagnosticInfo", "#2563EB" },
                hint    = { "DiagnosticHint", "#10B981" },
            },

            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]],
            },
        })

        -- ─────────────────────────────────────────────────────────────
        -- MENÚ DE INSERCIÓN (estilo code actions)
        -- ─────────────────────────────────────────────────────────────
        local keywords = {
            { label = " TODO", value = "TODO" },
            { label = " FIX",  value = "FIX" },
            { label = " WARN", value = "WARN" },
            { label = " NOTE", value = "NOTE" },
        }

        vim.keymap.set("n", "<leader>io", function()
            local ft = vim.bo.filetype
            local prefix
            if ft == "java" or ft == "groovy" or ft == "javascript" or ft == "typescript" then
                prefix = "// "
            elseif ft == "lua" then
                prefix = "-- "
            elseif ft == "yaml" or ft == "dockerfile" or ft == "sh" or ft == "bash" then
                prefix = "# "
            elseif ft == "markdown" then
                prefix = "<!-- "
            else
                prefix = "// "
            end

            local suffix = ft == "markdown" and " -->" or ""

            vim.ui.select(keywords, {
                prompt = "Tipo de comentario:",
                format_item = function(item)
                    return prefix .. item.label .. ": "
                end,
            }, function(choice)
                if not choice then return end

                local row = vim.api.nvim_win_get_cursor(0)[1]
                local current_line = vim.api.nvim_get_current_line()
                local new_line = current_line .. prefix .. choice.value .. ": " .. suffix

                vim.api.nvim_set_current_line(new_line)

                -- Cursor antes del suffix para escribir la descripción
                local col = #new_line - #suffix
                vim.api.nvim_win_set_cursor(0, { row, col })
                vim.cmd("startinsert!")
            end)
        end, { desc = "Insertar TODO comment" })

        -- ─────────────────────────────────────────────────────────────
        -- NAVEGACIÓN
        -- ─────────────────────────────────────────────────────────────
        vim.keymap.set("n", "]o", function()
            require("todo-comments").jump_next({ keywords = { "TODO", "FIX", "WARN", "NOTE" } })
        end, { desc = "TODO: Siguiente" })

        vim.keymap.set("n", "[o", function()
            require("todo-comments").jump_prev({ keywords = { "TODO", "FIX", "WARN", "NOTE" } })
        end, { desc = "TODO: Anterior" })

        -- Telescope: buscar en el proyecto
        vim.keymap.set("n", "<leader>ft",
            "<cmd>TodoTelescope keywords=TODO,FIX,WARN,NOTE<CR>",
            { desc = "TODO: Buscar en proyecto" })

        -- Trouble: ver en panel
        vim.keymap.set("n", "<leader>lT",
            "<cmd>Trouble todo toggle filter.include.tag={TODO,FIX,WARN,NOTE}<CR>",
            { desc = "TODO: Panel Trouble" })
    end,
}
