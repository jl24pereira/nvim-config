-- 1. Definir la tecla Leader (Espacio) ANTES de cargar plugins
vim.g.mapleader = " "

-- 2. Instalación automática de lazy.nvim
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

-- 3. Configuración de Plugins
require("lazy").setup({
    -- LSP y Java

    { "williamboman/mason.nvim", config = true },
    { 
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                handlers = {
                    -- 1. Configura automáticamente cualquier servidor que instales en Mason
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,
                    -- 2. EXCEPCIÓN: Java (jdtls) no lo toca, porque ya tienes tu archivo java.lua para eso
                    ["jdtls"] = function() end,
                }
            })
        end
    },
    { "neovim/nvim-lspconfig" },
    { "mfussenegger/nvim-jdtls" },

    -- Autocompletado (Estilo IntelliJ)
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
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
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end
    },

    -- Telescope: El buscador "Shift-Shift"
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Espacio + f + f
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Espacio + f + g (Buscar texto)
            -- BUSCAR MÉTODOS/CLASES (El verdadero Shift-Shift de IntelliJ)
            vim.keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols, {})
        end
    },

    -- Neo-tree: Explorador de archivos (Barra lateral)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', {}) -- Espacio + e
        end
    },

    -- Plugin para saber los comandos
    {
        "folke/which-key.nvim",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("which-key").setup({})
        end,
    },

    -- Plugin para cambiar color
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- Plugin para comentarios inteligentes (gc para línea, gb para bloque)
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },

    -- Plugin para barra inferior
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }
})

-- 4. Opciones de Interfaz y Calidad de Vida
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus" -- Permite copiar/pegar desde Windows con y/p

-- 5. ATAJOS GLOBALES LSP (AQUÍ VAN LOS COMANDOS DE NAVEGACIÓN)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Ir a Definición" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Ver Referencias" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Ir a Implementación" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Ver Documentación" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Renombrar" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Acciones de Código" })
-- Duplicar línea actual
vim.keymap.set('n', '<leader>d', 'yyp', { desc = 'Duplicar línea abajo' })
-- Duplicar selección
vim.keymap.set('v', '<leader>d', 'y`>p', { desc = 'Duplicar bloque abajo' })
-- ==========================================
-- NAVEGACIÓN DE BUFFERS (Pestañas)
-- ==========================================
-- Cerrar el buffer actual (sin cerrar Neovim)
vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { desc = "Cerrar buffer actual" })
-- Ver lista de buffers abiertos en Telescope
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = "Lista de buffers" })

-- Comentar línea con Ctrl + / (Normal mode)
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = "Comentar línea" })

-- Formateo Inteligente: Usa LSP si puede, si no, usa el nativo de Neovim
-- vim.keymap.set('n', '<leader>f', function()
    --     local bufnr = vim.api.nvim_get_current_buf()
    --     local clients = vim.lsp.get_clients({ bufnr = bufnr })
    --     local has_formatter = false
    --
    --     -- Revisa si algún servidor conectado sabe formatear
    --     for _, client in ipairs(clients) do
    --         if client.server_capabilities.documentFormattingProvider then
    --             has_formatter = true
    --             break
    --         end
    --     end
    --
    --     if has_formatter then
    --         vim.lsp.buf.format({ async = true })
    --         print("Formateado con LSP")
    --     else
    --         -- Si no hay LSP, guarda la posición, usa el formateo nativo (gg=G) y vuelve
    --         local save_pos = vim.fn.getpos(".")
    --         vim.cmd("normal! gg=G")
    --         vim.fn.setpos(".", save_pos)
    --         print("Formateado con motor nativo de Neovim")
    --     end
    -- end, { desc = "Formatear inteligente" })
    --
    -- Intercambiar j y k (abajo / arriba)
    vim.keymap.set({ 'n', 'v', 'o' }, 'j', 'k', { noremap = true, silent = true })
    vim.keymap.set({ 'n', 'v', 'o' }, 'k', 'j', { noremap = true, silent = true })

    -- Mover línea actual arriba / abajo
    vim.keymap.set('n', '<leader>j', ':m .-2<CR>==', { desc = 'Mover línea arriba' })
    vim.keymap.set('n', '<leader>k', ':m .+1<CR>==', { desc = 'Mover línea abajo' })

    vim.cmd[[colorscheme tokyonight]]

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.java",
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    -- Activar servidores para archivos Gradle y Groovy (Formato moderno Nvim 0.11+)
    vim.lsp.config("groovyls", {})
    vim.lsp.enable("groovyls")

    vim.lsp.config("gradle_ls", {})
    vim.lsp.enable("gradle_ls")

    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
                refresh_time = 16, -- ~60fps
                events = {
                    'WinEnter',
                    'BufEnter',
                    'BufWritePost',
                    'SessionLoadPost',
                    'FileChangedShellPost',
                    'VimResized',
                    'Filetype',
                    'CursorMoved',
                    'CursorMovedI',
                    'ModeChanged',
                },
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
