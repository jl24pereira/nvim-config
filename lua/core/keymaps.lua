-- =====================================================================
-- KEYMAPS — Atajos de teclado
-- Prefijos:
--   <leader>w  → Guardar / Salir
--   <leader>e  → Explorador de archivos
--   <leader>f  → Buscar (Telescope)
--   <leader>g  → LSP / Ir a... / Git
--   <leader>j  → Java (jdtls específico)
--   <leader>d  → Debug (DAP)
--   <leader>b  → Breakpoints
--   <leader>s  → Splits / Ventanas
--   <leader>t  → Tabs
--   <leader>q  → Quickfix
--   <leader>h  → Harpoon
--   <leader>r  → Refactor (rename, etc.)
--   <leader>c  → Diff / Merge
--   <leader>l  → LSP extras (diagnósticos)
-- =====================================================================

vim.g.mapleader = " "
local keymap = vim.keymap

-- =====================================================================
-- GUARDAR / SALIR
-- =====================================================================

keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Guardar" })
keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Guardar y salir" })
keymap.set("n", "<leader>qq", ":q!<CR>", { desc = "Salir sin guardar" })

-- =====================================================================
-- EXPLORADOR DE ARCHIVOS
-- =====================================================================

keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle explorador" })

-- =====================================================================
-- EDICIÓN RÁPIDA (sin prefijo leader, estilo Vim)
-- =====================================================================
-- Mover líneas arriba/abajo en modo normal y visual
keymap.set("n", "<leader>mj", ":m .+1<CR>==", { desc = "Mover línea abajo" })
keymap.set("n", "<leader>mk", ":m .-2<CR>==", { desc = "Mover línea arriba" })
keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Mover bloque abajo" })
keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Mover bloque arriba" })

-- Duplicar línea/bloque (movido a Alt para liberar <leader>j y <leader>k)
keymap.set("n", "<A-d>", "yyp", { desc = "Duplicar línea abajo" })
keymap.set("v", "<A-d>", "y`>p", { desc = "Duplicar bloque abajo" })

-- Abrir URL bajo el cursor
keymap.set("n", "gx", ":!xdg-open <c-r><c-a><CR>", { desc = "Abrir URL bajo cursor" })

-- =====================================================================
-- NAVEGACIÓN DE BUFFERS
-- =====================================================================

keymap.set("n", "<leader>x", ":Bdelete<CR>", { desc = "Cerrar buffer actual" })

-- =====================================================================
-- SPLITS / VENTANAS  (<leader>s)
-- =====================================================================

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Igualar tamaños" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Cerrar split" })
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Maximizar/restaurar" })

-- Redimensionar splits
keymap.set("n", "<leader>sj", "<C-w>-", { desc = "Reducir altura" })
keymap.set("n", "<leader>sk", "<C-w>+", { desc = "Aumentar altura" })
keymap.set("n", "<leader>sl", "<C-w>>5", { desc = "Aumentar ancho" })
keymap.set("n", "<leader>s<", "<C-w><5", { desc = "Reducir ancho" })

-- Navegar entre splits con Ctrl+hjkl (sin leader, más ágil)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir al split izquierdo" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir al split inferior" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir al split superior" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir al split derecho" })

-- =====================================================================
-- TABS  (<leader>t)
-- =====================================================================

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Nueva pestaña" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Cerrar pestaña" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Siguiente pestaña" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Pestaña anterior" })

-- =====================================================================
-- QUICKFIX  (<leader>q)
-- =====================================================================

keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Abrir quickfix" })
keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Cerrar quickfix" })
keymap.set("n", "<leader>qf", ":cfirst<CR>", { desc = "Primer elemento" })
keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Siguiente elemento" })
keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Elemento anterior" })
keymap.set("n", "<leader>ql", ":clast<CR>", { desc = "Último elemento" })

-- =====================================================================
-- GIT  (<leader>g)
-- =====================================================================

keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Toggle Git Blame" })

-- =====================================================================
-- DIFF / MERGE  (<leader>c)
-- =====================================================================

keymap.set("n", "<leader>cc", ":diffput<CR>", { desc = "Enviar cambio (diffput)" })
keymap.set("n", "<leader>cj", ":diffget 1<CR>", { desc = "Obtener cambio (Local)" })
keymap.set("n", "<leader>ck", ":diffget 3<CR>", { desc = "Obtener cambio (Remoto)" })
keymap.set("n", "<leader>cn", "]c", { desc = "Siguiente bloque diff" })
keymap.set("n", "<leader>cp", "[c", { desc = "Bloque diff anterior" })

-- =====================================================================
-- TELESCOPE / BUSCAR  (<leader>f)
-- =====================================================================

keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Buscar archivos" })

keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
end, { desc = "Buscar texto (grep)" })

keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { desc = "Buscar buffers abiertos" })

keymap.set("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
end, { desc = "Buscar en ayuda" })

keymap.set("n", "<leader>fs", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Buscar en archivo actual" })

keymap.set("n", "<leader>fm", function()
    require("telescope.builtin").treesitter({ symbols = { "function", "method" } })
end, { desc = "Buscar métodos/funciones" })

keymap.set("n", "<leader>fp", function()
    require("telescope").extensions.projects.projects()
end, { desc = "Buscar proyectos" })

keymap.set("n", "<leader>fo", function()
    require("telescope").extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.expand("%:p:h"),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        initial_mode = "normal",
        layout_config = { height = 0.4, width = 0.6 },
        theme = "dropdown"
    })
end, { desc = "Explorador Telescope (directorio actual)" })

keymap.set("n", "<leader>fj", function()
    require("telescope").extensions.file_browser.file_browser({
        path = vim.fn.expand("~/projects/java"), -- Ajusta a tu ruta real de proyectos
        respect_gitignore = false,
        hidden = false,
        grouped = true,
        initial_mode = "normal",
    })
end, { desc = "Mis proyectos Java" })

-- =====================================================================
-- LSP / IR A...  (<leader>g)
-- =====================================================================

keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Documentación hover" })
keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Ir a definición" })
keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Ir a declaración" })
keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Ir a implementación" })
keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Ir a tipo" })
keymap.set("n", "<leader>gg", vim.lsp.buf.hover, { desc = "Info hover" })
keymap.set("n", "<leader>gs", vim.lsp.buf.signature_help, { desc = "Ayuda de firma" })

keymap.set("n", "<leader>gr", function()
    require("telescope.builtin").lsp_references()
end, { desc = "Ver referencias" })

keymap.set("n", "<leader>fi", function()
    require("telescope.builtin").lsp_incoming_calls()
end, { desc = "Llamadas entrantes (LSP)" })

keymap.set("n", "<leader>gf", function()
    require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 5000 })
end, { desc = "Formatear archivo" })

keymap.set("v", "<leader>gf", function()
    require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 5000 })
end, { desc = "Formatear selección" })

keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, { desc = "Code actions" })

-- =====================================================================
-- REFACTOR  (<leader>r)
-- =====================================================================

keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Renombrar símbolo" })

-- =====================================================================
-- LSP DIAGNÓSTICOS  (<leader>l)
-- =====================================================================

keymap.set("n", "<leader>ll", vim.diagnostic.open_float, { desc = "Ver diagnóstico flotante" })
keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, { desc = "Siguiente error" })
keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, { desc = "Error anterior" })
keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "Símbolos del documento" })

-- =====================================================================
-- JAVA  (<leader>j)
-- =====================================================================

keymap.set("n", "<leader>jo", function()
    if vim.bo.filetype == "java" then require("jdtls").organize_imports() end
end, { desc = "Organizar imports" })

keymap.set("n", "<leader>ju", function()
    if vim.bo.filetype == "java" then require("jdtls").update_projects_config() end
end, { desc = "Actualizar config del proyecto" })

keymap.set("n", "<leader>jc", function()
    if vim.bo.filetype == "java" then require("jdtls").test_class() end
end, { desc = "Testear clase completa" })

keymap.set("n", "<leader>jm", function()
    if vim.bo.filetype == "java" then require("jdtls").test_nearest_method() end
end, { desc = "Testear método más cercano" })

keymap.set("n", "<leader>je", function()
    if vim.bo.filetype == "java" then require("jdtls").extract_variable() end
end, { desc = "Extraer variable" })

keymap.set("v", "<leader>jx", function()
    if vim.bo.filetype == "java" then require("jdtls").extract_method(true) end
end, { desc = "Extraer método (selección)" })

-- =====================================================================
-- DEBUG DAP  (<leader>d)
-- =====================================================================

keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continuar / Iniciar" })
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle REPL" })
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Ejecutar última config" })

keymap.set("n", "<leader>du", function()
    require("dapui").toggle()
end, { desc = "Toggle UI de debug" })

keymap.set("n", "<leader>di", function()
    require("dap.ui.widgets").hover()
end, { desc = "Inspeccionar variable" })

keymap.set("n", "<leader>d?", function()
    local w = require("dap.ui.widgets")
    w.centered_float(w.scopes)
end, { desc = "Ver scopes" })

keymap.set("n", "<leader>dx", function()
    require("dap").disconnect()
    require("dapui").close()
end, { desc = "Desconectar debug" })

keymap.set("n", "<leader>dt", function()
    require("dap").terminate()
    require("dapui").close()
end, { desc = "Terminar debug" })


-- Telescope + DAP

keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<CR>", { desc = "Ver frames (Telescope)" })
keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<CR>", { desc = "Comandos DAP (Telescope)" })
keymap.set("n", "<leader>de", function()
    require("telescope.builtin").diagnostics({ default_text = ":E:" })
end, { desc = "Buscar errores (Telescope)" })

-- =====================================================================
-- BREAKPOINTS  (<leader>b)
-- =====================================================================

keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
    { desc = "Toggle breakpoint" })

keymap.set("n", "<leader>bc", function()
    require("dap").set_breakpoint(vim.fn.input("Condición: "))
end, { desc = "Breakpoint condicional" })

keymap.set("n", "<leader>bl", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: "))
end, { desc = "Breakpoint de log" })

keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<CR>",
    { desc = "Limpiar breakpoints" })

keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<CR>",
    { desc = "Listar breakpoints (Telescope)" })

-- =====================================================================
-- HARPOON  (<leader>h)
-- =====================================================================

keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end,
    { desc = "Agregar archivo a Harpoon" })

keymap.set("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end,
    { desc = "Abrir menú Harpoon" })

keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Archivo 1" })
keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Archivo 2" })
keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Archivo 3" })
keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end, { desc = "Archivo 4" })
keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end, { desc = "Archivo 5" })
keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end, { desc = "Archivo 6" })
keymap.set("n", "<leader>h7", function() require("harpoon.ui").nav_file(7) end, { desc = "Archivo 7" })
keymap.set("n", "<leader>h8", function() require("harpoon.ui").nav_file(8) end, { desc = "Archivo 8" })
keymap.set("n", "<leader>h9", function() require("harpoon.ui").nav_file(9) end, { desc = "Archivo 9" })

-- =====================================================================
-- NEOTEST — Agregar al final de keymaps.lua, dentro del grupo <leader>j
-- =====================================================================

-- Correr el test más cercano al cursor
keymap.set("n", "<leader>jtr", function()
    require("neotest").run.run()
end, { desc = "Test: Correr más cercano" })

-- Correr todos los tests del archivo actual
keymap.set("n", "<leader>jtf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test: Correr archivo" })

-- Correr toda la suite del proyecto
keymap.set("n", "<leader>jts", function()
    require("neotest").run.run({ suite = true })
end, { desc = "Test: Correr suite completa" })

-- Detener el test que está corriendo
keymap.set("n", "<leader>jtu", function()
    require("neotest").run.stop()
end, { desc = "Test: Detener" })

-- Debuggear el test más cercano (usa DAP)
keymap.set("n", "<leader>jtd", function()
    require("neotest").run.run({ strategy = "dap" })
end, { desc = "Test: Debug test más cercano" })

-- Ver output del último test
keymap.set("n", "<leader>jto", function()
    require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Test: Ver output" })

-- Toggle panel de resumen visual
keymap.set("n", "<leader>jtt", function()
    require("neotest").summary.toggle()
end, { desc = "Test: Toggle panel resumen" })

-- Ver diagnósticos de tests en panel flotante
keymap.set("n", "<leader>jtl", function()
    require("neotest").output_panel.toggle()
end, { desc = "Test: Toggle panel de log" })

-- Saltar al test fallido anterior/siguiente
keymap.set("n", "[t", function()
    require("neotest").jump.prev({ status = "failed" })
end, { desc = "Test: Ir al fallo anterior" })

keymap.set("n", "]t", function()
    require("neotest").jump.next({ status = "failed" })
end, { desc = "Test: Ir al siguiente fallo" })
