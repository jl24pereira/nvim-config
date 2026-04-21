-- =====================================================================
-- CONFIGURACIONES BASE
-- =====================================================================
-- Definir la tecla Leader (Espacio) ANTES de cargar cualquier otra cosa
vim.g.mapleader = " "

-- Opciones de editor
vim.opt.number = true             -- Muestra el número de línea actual
vim.opt.relativenumber = true     -- Números relativos para saltar fácilmente
vim.opt.shiftwidth = 4            -- Tamaño de la indentación
vim.opt.tabstop = 4               -- Tamaño del tabulador visual
vim.opt.expandtab = true          -- Convierte tabs en espacios
vim.opt.clipboard = "unnamedplus" -- Usa el portapapeles del sistema (Windows/Mac/Linux)
vim.opt.shell = "bash"

vim.diagnostic.config({
    virtual_text = false,
    float = {
        border = "rounded"
    },
    signs = true,
    underline = true
})

vim.opt.termguicolors = true

-- Autorecarga cuando Claude Code modifica archivos externos
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    pattern = "*",
    command = "checktime",
})
