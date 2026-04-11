-- =====================================================================
-- TODOS LOS ATAJOS DE TECLADO (Keymaps)
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
vim.keymap.set('n', '<leader>x', ':Bdelete<CR>', { desc = "Cerrar buffer actual" })
vim.keymap.set('n', '<leader>bl', ':bn<CR>', { desc = "Mover a buffer siguiente" })
vim.keymap.set('n', '<leader>bh', ':bp<CR>', { desc = "Mover a buffer anterior" })
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = "Comentar línea" })

-- --- PLUGINS (Telescope y Neo-tree) ---
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Abrir explorador de archivos" })
-- Atajos para cambiar entre fuentes de Neo-tree
vim.keymap.set("n", "<leader>nf", ":Neotree focus filesystem<CR>", { desc = "Neo-tree Files" })
vim.keymap.set("n", "<leader>nb", ":Neotree focus buffers<CR>", { desc = "Neo-tree Buffers" })
vim.keymap.set("n", "<leader>ng", ":Neotree focus git_status<CR>", { desc = "Neo-tree Git" })

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


