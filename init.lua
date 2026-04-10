-- =====================================================================
-- 1. CONFIGURACIONES BASE (Opciones de Interfaz y Calidad de Vida)
-- =====================================================================
-- Definir la tecla Leader (Espacio) ANTES de cargar cualquier otra cosa
vim.g.mapleader = " "

-- Opciones de editor
vim.opt.number = true              -- Muestra el número de línea actual
vim.opt.relativenumber = true      -- Números relativos para saltar fácilmente
vim.opt.shiftwidth = 4             -- Tamaño de la indentación
vim.opt.tabstop = 4                -- Tamaño del tabulador visual
vim.opt.expandtab = true           -- Convierte tabs en espacios
vim.opt.clipboard = "unnamedplus"  -- Usa el portapapeles del sistema (Windows/Mac/Linux)

-- =====================================================================
-- 2. TODOS LOS ATAJOS DE TECLADO (Keymaps)
-- =====================================================================

-- --- GLOBALES ---
-- Intercambiar j y k (navegación invertida)
vim.keymap.set({ 'n', 'v', 'o' }, 'j', 'k', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'o' }, 'k', 'j', { noremap = true, silent = true })

-- Mover línea actual arriba / abajo
vim.keymap.set('n', '<leader>j', ':m .-2<CR>==', { desc = 'Mover línea arriba' })
vim.keymap.set('n', '<leader>k', ':m .+1<CR>==', { desc = 'Mover línea abajo' })

-- Duplicar líneas
vim.keymap.set('n', '<leader>d', 'yyp', { desc = 'Duplicar línea abajo' })
vim.keymap.set('v', '<leader>d', 'y`>p', { desc = 'Duplicar bloque abajo' })

-- Navegación de Buffers (Pestañas) y Comentarios
vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { desc = "Cerrar buffer actual" })
vim.keymap.set('n', '<leader>bl', ':bn<CR>', { desc = "Mover a buffer siguiente" })
vim.keymap.set('n', '<leader>bh', ':bp<CR>', { desc = "Mover a buffer anterior" })
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = "Comentar línea" })

-- --- PLUGINS (Telescope y Neo-tree) ---
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Abrir explorador de archivos" })
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = "Buscar archivos" })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = "Buscar texto en proyecto" })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = "Lista de buffers" })
vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = "Ayuda de Neovim" })
vim.keymap.set('n', '<leader>fp', function() require('telescope').extensions.projects.projects() end, { desc = "Buscar Proyectos" })
-- vim.keymap.set('n', '<leader>fo', ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "Explorar carpetas" })

-- Abrir el explorador en un panel flotante centrado (estilo dropdown)
vim.keymap.set('n', '<leader>fo', function()
    require('telescope').extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.expand('%:p:h'),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        initial_mode = "normal", -- O "insert" si prefieres escribir de una vez
        layout_config = { height = 0.4, width = 0.6 }, -- Ajusta el tamaño aquí
        theme = "dropdown", -- 🟢 Esto es lo que lo hace ver como un panel flotante
    })
end, { desc = "Explorar carpetas" })

-- Salto directo a tu carpeta de estudios/trabajo
vim.keymap.set('n', '<leader>fj', function()
    require('telescope').extensions.file_browser.file_browser({
        path = "C:/Users/Jose Luis Pereira/Documents", -- 🟢 Cambia esto por tu ruta real
        respect_gitignore = false,
    })
end, { desc = "Mis Proyectos Java" })

-- --- LSP (Motor de Inteligencia de Código) ---
-- 🟢 Usamos Telescope con el tema 'dropdown' para ventanas flotantes
vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions({ theme = 'dropdown' }) end, { desc = "Ir a Definición" })
vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references({ theme = 'dropdown' }) end, { desc = "Ver Referencias" })
vim.keymap.set('n', 'gi', function() require('telescope.builtin').lsp_implementations({ theme = 'dropdown' }) end, { desc = "Ir a Implementación" })

vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Ver Documentación" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Renombrar" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Acciones de Código" })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Ver diagnóstico LSP (Error)" })

-- =====================================================================
-- 3. GESTOR DE PLUGINS (Bootstrapping lazy.nvim)
-- =====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- 4. PLUGINS Y SU CONFIGURACIÓN
-- =====================================================================
require("lazy").setup({
    -- Tema (Colorscheme)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    -- LSP, Mason y Java
    { "williamboman/mason.nvim", config = true },
    { 
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,
                    
                    -- 🟢 RESTAURADA: La excepción para que Mason no rompa a Java
                    -- ["jdtls"] = function() end, 

                    -- ["gradle_ls"] = function() end,
                }
            })
        end
    },
    -- { "neovim/nvim-lspconfig" },
    
    -- 🟢 RESTAURADO: El motor de Java especializado
    { "mfussenegger/nvim-jdtls" }, 

    -- Autocompletado y Snippets (Generador de Documentación)
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            -- Definimos la plantilla secreta "jdoc" exclusivamente para Java
            ls.add_snippets("java", {
                s("jdoc", {
                    t({"/**", " * "}), i(1, "Descripción del método..."),
                    t({"", " * @param "}), i(2, "nombre"),
                    t({"", " * @return "}), i(3, "resultado"),
                    t({"", " */"})
                })
            })

            local cmp = require("cmp")
            cmp.setup({
                snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = 'luasnip', priority = 1000 }, 
                    { name = 'nvim_lsp', priority = 750 }, 
                }, {
                    { name = 'buffer' },
                })
            })
        end
    },

    -- Telescope, Proyectos y Explorador de Carpetas
    {
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
                patterns = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
            })

            telescope.setup({
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                    ["file_browser"] = {
                        -- theme = "ivy",
                        hijack_netrw = true, -- Reemplaza el explorador nativo
                        mappings = {
                            ["i"] = {
                                -- 🟢 Alt + s: Selecciona la carpeta y la fija como proyecto (CWD)
                                ["<A-s>"] = fb_actions.change_cwd,
                                -- 🟢 Alt + c: Crea un archivo/carpeta nuevo
                                ["<A-c>"] = fb_actions.create,
                                -- 🟢 Alt + r: Renombra el archivo/carpeta bajo el cursor
                                ["<A-r>"] = fb_actions.rename,
                                -- 🟢 Alt + m: Mueve el archivo/carpeta
                                ["<A-m>"] = fb_actions.move,
                                -- 🟢 Alt + d: Borra el archivo/carpeta
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
        end
    },
       
    -- Neo-tree (Explorador de archivos)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            -- 🟢 PARCHE DE SEGURIDAD:
            -- Evita que Neo-tree explote al cerrar ventanas de Telescope (file_browser)
            local manager = require("neo-tree.sources.manager")
            local old_get_state = manager.get_state
            manager.get_state = function(source_name, tabnr)
                if not source_name then return {} end
                return old_get_state(source_name, tabnr)
            end

            -- Configuración de Neo-tree
            require("neo-tree").setup({
                filesystem = {
                    bind_to_cwd = true,
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                },
                window = {
                    mappings = {
                        ["<space>"] = "none", -- Para que no interfiera con tu tecla Leader
                    }
                }
            })
        end
    },

    -- Utilidades Visuales
    {
        "folke/which-key.nvim",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("which-key").setup({})
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
            }
        end
    },

    -- Motor de Inteligencia Sintáctica y Coloreado (Treesitter)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" }, 
        config = function()
            -- Obliga a Treesitter a usar Clang en Windows
            vim.env.CC = "clang" 
            require("nvim-treesitter.install").compilers = { "clang" }

            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then return end

            configs.setup({
                ensure_installed = { "c", "lua", "java", "markdown" },
                highlight = { enable = true }, 
                indent = { enable = true },
            })
        end
    },
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
})

-- =====================================================================
-- 5. CONFIGURACIÓN VISUAL ADICIONAL
-- =====================================================================
-- Configuración visual de los errores/diagnósticos
vim.diagnostic.config({
    virtual_text = false,
    float = { border = "rounded" },
    signs = true,
    underline = true,
}) -- 🟢 PARÉNTESIS CORREGIDO AQUÍ

vim.opt.termguicolors = true
require("bufferline").setup{}
