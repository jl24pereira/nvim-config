return {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        -- Adaptador para Java (JUnit 4/5, Maven y Gradle)
        "rcasia/neotest-java",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-java")({
                    -- Detecta automáticamente si es Maven o Gradle
                    -- Si tienes un proyecto mixto, fuerza uno:
                    build_tool = "gradle",
                    gradle_wrapper = "gradlew",
                    -- build_tool = "maven",

                    -- Classpath extra si necesitas jars adicionales
                    -- extra_classpath = "",

                    -- Habilita el modo de test para proyectos Spring Boot
                    -- (ejecuta con el perfil de test activo)
                    project_type = "spring",
                }),
            },

            -- Muestra el resultado inline en el código
            output = {
                enabled = true,
                open_on_run = false, -- No abrir automáticamente; usa <leader>jto para verlo
            },

            -- Panel de resumen de tests (árbol visual)
            summary = {
                enabled = true,
                animated = true,
                follow = true, -- Sigue el test que se está ejecutando
                expand_errors = true,
                mappings = {
                    expand       = { "<CR>", "<2-LeftMouse>" },
                    expand_all   = "e",
                    output       = "o",
                    short        = "O",
                    attach       = "a",
                    jumpto       = "i",
                    stop         = "u",
                    run          = "r",
                    debug        = "d",
                    mark         = "m",
                    run_marked   = "R",
                    debug_marked = "D",
                    target       = "t",
                    clear_target = "T",
                    next_failed  = "J",
                    prev_failed  = "K",
                    watch        = "w",
                }
            },

            -- Íconos de estado en el gutter
            icons = {
                child_indent       = "│",
                child_prefix       = "├",
                collapsed          = "─",
                expanded           = "╮",
                failed             = "✗",
                final_child_indent = " ",
                final_child_prefix = "╰",
                non_collapsible    = "─",
                notify             = "",
                passed             = "✓",
                running            = "",
                running_animated   = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                skipped            = "↠",
                unknown            = "?",
                watching           = "",
            },

            -- Signos en el gutter del editor
            status = {
                enabled      = true,
                signs        = true,
                virtual_text = false, -- Evita conflicto con virtual_text de diagnósticos
            },

            -- Estrategia de ejecución (integrated = terminal integrado de Neovim)
            default_strategy = "integrated",

            -- Configuración del terminal integrado
            strategies = {
                integrated = {
                    height = 40,
                    width  = 120,
                },
            },
        })
    end,
}
