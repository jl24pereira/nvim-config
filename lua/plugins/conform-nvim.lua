return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                -- Cubrimos todas las posibilidades de detección de Neovim
                groovy = { "npm_groovy_lint" },
                gradle = { "npm_groovy_lint" },
                java = {},
                markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
            },
            formatters = {
                npm_groovy_lint = {
                    -- En Windows, Mason instala un .CMD o .ps1
                    -- Si esto falla, intenta cambiarlo a "npm-groovy-lint.CMD"
                    command = "npm-groovy-lint",
                    args = { "--format", "-" },
                    stdin = true,
                },
                markdown_toc = {
                    condition = function(_, ctx)
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                            if line:find("<!%-%- toc %-%->") then
                                return true
                            end
                        end
                    end,
                },
                markdownlint_cli2 = {
                    condition = function(_, ctx)
                        local diag = vim.tbl_filter(function(d)
                            return d.source == "markdownlint"
                        end, vim.diagnostic.get(ctx.buf))
                        return #diag > 0
                    end,
                }
            },
            format_on_save = {
                timeout_ms = 10000, -- Aumentamos el tiempo porque npm en Windows es más lento
                lsp_format = "fallback"
            },
        })
    end,
}
