return {
    "williamboman/mason.nvim",
    cmd = "Mason", -- Optimización: Solo carga el plugin si escribes el comando
    keys = {{
        "<leader>cm",
        "<cmd>Mason<cr>",
        desc = "Abrir panel de Mason"
    }},
    build = ":MasonUpdate", -- Actualiza el catálogo de servidores automáticamente al instalar
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })
    end
}
