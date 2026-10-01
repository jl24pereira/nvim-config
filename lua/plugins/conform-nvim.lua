return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                groovy   = { "npm_groovy_lint" },
                gradle   = { "npm_groovy_lint" },
                markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
                yaml     = { "prettier" },
                -- java y json no tienen formateador propio: usan el del LSP (jdtls / jsonls)
            },
            formatters = {
                npm_groovy_lint = {
                    command = "npm-groovy-lint",
                    args = { "--format", "-" },
                    stdin = true,
                },
                -- Solo si el archivo tiene la marca <!-- toc -->
                ["markdown-toc"] = {
                    condition = function(_, ctx)
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                            if line:find("<!%-%- toc %-%->") then
                                return true
                            end
                        end
                        return false
                    end,
                },
                -- Solo si none-ls detectó problemas de markdownlint en el archivo
                ["markdownlint-cli2"] = {
                    condition = function(_, ctx)
                        local diag = vim.tbl_filter(function(d)
                            return d.source == "markdownlint-cli2"
                        end, vim.diagnostic.get(ctx.buf))
                        return #diag > 0
                    end,
                },
            },
            format_on_save = {
                timeout_ms = 10000,
                lsp_format = "fallback",
            },
        })
    end,
}
