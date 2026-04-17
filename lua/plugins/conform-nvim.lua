return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                -- Cubrimos todas las posibilidades de detección de Neovim
                groovy = { "npm_groovy_lint" },
                gradle = { "npm_groovy_lint" },
            },
            formatters = {
                npm_groovy_lint = {
                    -- En Windows, Mason instala un .CMD o .ps1
                    -- Si esto falla, intenta cambiarlo a "npm-groovy-lint.CMD"
                    command = "npm-groovy-lint",
                    args = { "--format", "-" },
                    stdin = true,
                },
            },
            format_on_save = {
                timeout_ms = 5000,    -- Aumentamos el tiempo porque npm en Windows es más lento
                lsp_fallback = false, -- Ya sabemos que el LSP no funciona, así que lo ignoramos
            },
        })
    end,
}
