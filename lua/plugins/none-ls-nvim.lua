return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local nls = require("null-ls")
        nls.setup({
            sources = {
                nls.builtins.diagnostics.markdownlint_cli2, -- Markdown
                nls.builtins.diagnostics.hadolint,          -- Dockerfile
            },
        })
    end,
}
