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
  { "williamboman/mason-lspconfig.nvim" },
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
  {
  "folke/which-key.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("which-key").setup({})
  end,
},
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
},
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
-- Formatear código (como Ctrl+Alt+L en IntelliJ)
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "Formatear archivo" })
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
