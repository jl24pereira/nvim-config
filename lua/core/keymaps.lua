-- =====================================================================
-- TODOS LOS ATAJOS DE TECLADO (Keymaps)
-- =====================================================================
vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------------------------------------------------------------------
-- GENERAL / ARCHIVOS
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Guardar y salir" })
keymap.set("n", "<leader>qq", ":q!<CR>", { desc = "Salir sin guardar" })
keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Guardar" })
keymap.set("n", "gx", ":!open <c-r><c-a><CR>", { desc = "Abrir URL bajo cursor" })

-- ---------------------------------------------------------------------
-- GESTIÓN DE VENTANAS (Splits)
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Igualar anchos" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Cerrar split" })
keymap.set("n", "<leader>sj", "<C-w>-", { desc = "Reducir altura (-)" })
keymap.set("n", "<leader>sk", "<C-w>+", { desc = "Aumentar altura (+)" })
keymap.set("n", "<leader>sl", "<C-w>>5", { desc = "Aumentar ancho (>)" })
keymap.set("n", "<leader>s<", "<C-w><5", { desc = "Reducir ancho (<)" }) -- Corregido conflicto con 'sh'

-- ---------------------------------------------------------------------
-- EDICIÓN: MOVER Y DUPLICAR LÍNEAS
-- ---------------------------------------------------------------------
keymap.set('n', '<leader>k', ':m .-2<CR>==', { desc = 'Mover línea arriba' })
keymap.set('n', '<leader>j', ':m .+1<CR>==', { desc = 'Mover línea abajo' })

-- Corregido: Usar 'dd' para evitar lag/conflictos con los comandos de Debug (DAP)
keymap.set('n', '<leader>dd', 'yyp', { desc = 'Duplicar línea abajo' })
keymap.set('v', '<leader>dd', 'y`>p', { desc = 'Duplicar bloque abajo' })

-- ---------------------------------------------------------------------
-- NAVEGACIÓN DE BUFFERS Y TABS
-- ---------------------------------------------------------------------
keymap.set('n', '<leader>x', ':Bdelete<CR>', { desc = "Cerrar buffer actual" })
keymap.set('n', '<leader>b<', ':bn<CR>', { desc = "Siguiente buffer" })
keymap.set('n', '<leader>b>', ':bp<CR>', { desc = "Buffer anterior" })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Nueva pestaña" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Cerrar pestaña" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Siguiente pestaña" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Pestaña anterior" })

-- ---------------------------------------------------------------------
-- DIFF Y MERGE
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>cc", ":diffput<CR>", { desc = "Diff: Enviar cambio" })
keymap.set("n", "<leader>cj", ":diffget 1<CR>", { desc = "Diff: Obtener (Local)" })
keymap.set("n", "<leader>ck", ":diffget 3<CR>", { desc = "Diff: Obtener (Remoto)" })
keymap.set("n", "<leader>cn", "]c", { desc = "Diff: Siguiente bloque" })
keymap.set("n", "<leader>cp", "[c", { desc = "Diff: Bloque anterior" })

-- ---------------------------------------------------------------------
-- QUICKFIX LIST
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Quickfix: Abrir" })
keymap.set("n", "<leader>qf", ":cfirst<CR>", { desc = "Quickfix: Ir al primero" })
keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Quickfix: Ir al siguiente" })
keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Quickfix: Ir al anterior" })
keymap.set("n", "<leader>ql", ":clast<CR>", { desc = "Quickfix: Ir al último" })
keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Quickfix: Cerrar" })

-- ---------------------------------------------------------------------
-- PLUGINS VARIOS (Maximizer, NeoTree, GitBlame)
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Alternar Maximizar" })
keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Explorador de archivos" })
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Git: Alternar Blame" })

-- ---------------------------------------------------------------------
-- TELESCOPE
-- ---------------------------------------------------------------------
keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = "Buscar archivos" })
keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = "Buscar texto (Grep)" })
keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = "Buscar buffers" })
keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = "Buscar en ayuda" })
keymap.set('n', '<leader>fs', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = "Buscar en archivo actual" })
keymap.set('n', '<leader>fi', function() require('telescope.builtin').lsp_incoming_calls() end, { desc = "LSP: Llamadas entrantes" })
keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({symbols = {'function', 'method'}}) end, { desc = "Buscar métodos (Treesitter)" })
keymap.set('n', '<leader>ft', function()
    local success, node = pcall(function() return require('nvim-tree.lib').get_node_at_cursor() end)
    if not success or not node then return end
    require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
end, { desc = "Grep en directorio actual" })
keymap.set('n', '<leader>fo', function()
    require('telescope').extensions.file_browser.file_browser({
        path = "%:p:h", cwd = vim.fn.expand('%:p:h'), respect_gitignore = false,
        hidden = true, grouped = true, initial_mode = "normal",
        layout_config = {height = 0.4, width = 0.6}, theme = "dropdown"
    })
end, { desc = "Explorador Telescope" })
keymap.set('n', '<leader>fj', function()
    require('telescope').extensions.file_browser.file_browser({
        -- ATENCIÓN: Actualicé la ruta por tu cambio de usuario reciente
        path = "C:/Users/Jose Luis Pereira/Documents", 
        respect_gitignore = false
    })
end, { desc = "Mis Proyectos Java" })

-- ---------------------------------------------------------------------
-- HARPOON
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Harpoon: Archivo 1" })
keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Harpoon: Archivo 2" })
keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Harpoon: Archivo 3" })
keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end, { desc = "Harpoon: Archivo 4" })
keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end, { desc = "Harpoon: Archivo 5" })
keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end, { desc = "Harpoon: Archivo 6" })
keymap.set("n", "<leader>h7", function() require("harpoon.ui").nav_file(7) end, { desc = "Harpoon: Archivo 7" })
keymap.set("n", "<leader>h8", function() require("harpoon.ui").nav_file(8) end, { desc = "Harpoon: Archivo 8" })
keymap.set("n", "<leader>h9", function() require("harpoon.ui").nav_file(9) end, { desc = "Harpoon: Archivo 9" })

-- ---------------------------------------------------------------------
-- LSP (Motor de Inteligencia de Código)
-- ---------------------------------------------------------------------
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "LSP: Info (Hover)" })
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "LSP: Definición" })
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = "LSP: Declaración" })
keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = "LSP: Implementación" })
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = "LSP: Tipo de definición" })
keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', { desc = "LSP: Referencias" })
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = "LSP: Ayuda de firma" })
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = "LSP: Renombrar" })
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', { desc = "LSP: Formatear" })
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', { desc = "LSP: Formatear selección" })
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "LSP: Code Actions" })
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "LSP: Ver error" })
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "LSP: Error anterior" })
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "LSP: Siguiente error" })
keymap.set('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { desc = "LSP: Símbolos" })
keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>', { desc = "LSP: Autocompletar" })

-- Sobrescrituras LSP
keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP: Ver Documentación" })
keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "LSP: Renombrar" })
keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP: Code Actions" })
keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "LSP: Diagnóstico Flotante" })

-- Comandos específicos para Java
keymap.set("n", '<leader>go', function() if vim.bo.filetype == 'java' then require('jdtls').organize_imports() end end, { desc = "Java: Organizar Imports" })
keymap.set("n", '<leader>gu', function() if vim.bo.filetype == 'java' then require('jdtls').update_projects_config() end end, { desc = "Java: Actualizar Config" })
keymap.set("n", '<leader>tc', function() if vim.bo.filetype == 'java' then require('jdtls').test_class() end end, { desc = "Java: Testear Clase" })
keymap.set("n", '<leader>tm', function() if vim.bo.filetype == 'java' then require('jdtls').test_nearest_method() end end, { desc = "Java: Testear Método" })

-- ---------------------------------------------------------------------
-- DEBUGGING (DAP)
-- ---------------------------------------------------------------------
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Debug: Alternar Breakpoint" })
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condición: '))<cr>", { desc = "Debug: Breakpoint Condicional" })
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log: '))<cr>", { desc = "Debug: Breakpoint de Log" })
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "Debug: Limpiar Breakpoints" })
keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', { desc = "Debug: Listar Breakpoints" })
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", { desc = "Debug: Continuar (Play)" })
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Debug: Step Over" })
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Debug: Step Into" })
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", { desc = "Debug: Step Out" })

-- Cambiado de 'dd' a 'dx' para permitir duplicar líneas con 'dd'
keymap.set("n", '<leader>dx', function() require('dap').disconnect(); require('dapui').close(); end, { desc = "Debug: Desconectar" })

keymap.set("n", '<leader>dt', function() require('dap').terminate(); require('dapui').close(); end, { desc = "Debug: Terminar" })
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", { desc = "Debug: Consola REPL" })
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "Debug: Ejecutar último" })
keymap.set("n", '<leader>di', function() require"dap.ui.widgets".hover() end, { desc = "Debug: Info variable" })
keymap.set("n", '<leader>d?', function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end, { desc = "Debug: Ver Scopes" })
keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>', { desc = "Debug: Frames" })
keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>', { desc = "Debug: Comandos DAP" })
keymap.set("n", '<leader>de', function() require('telescope.builtin').diagnostics({default_text = ":E:"}) end, { desc = "Debug: Buscar Errores" })

-- ---------------------------------------------------------------------
-- EJECUCIÓN (RUN)
-- ---------------------------------------------------------------------
-- =====================================================================
-- EJECUCIÓN (RUN) - Solución nativa para Windows
-- =====================================================================

-- 1. Ejecutar Spring Boot (Módulo container-service)
keymap.set('n', '<leader>rc', function()
    vim.cmd('split | term')
    vim.api.nvim_chan_send(vim.b.terminal_job_id, "./gradlew bootRun\r")
end, { desc = "Run: Spring Boot (Container)" })

-- 2. Ejecutar Proyecto Java con Gradle
keymap.set('n', '<leader>rj', function()
    vim.cmd('split | term')
    vim.api.nvim_chan_send(vim.b.terminal_job_id, "./gradlew run\r")
end, { desc = "Run: Proyecto Java (Gradle)" })

-- 3. Ejecutar Archivo Suelto
keymap.set('n', '<leader>rs', function()
    -- Capturamos la ruta absoluta del archivo ANTES de abrir la terminal
    local filepath = vim.fn.expand('%:p') 
    
    if filepath == "" or filepath == nil then
        print("No hay un archivo válido para ejecutar")
        return
    end

    vim.cmd('split | term')
    -- Mandamos el comando java asegurando la ruta entre comillas
    vim.api.nvim_chan_send(vim.b.terminal_job_id, 'java "' .. filepath .. '"\r')
end, { desc = "Run: Archivo Suelto" })