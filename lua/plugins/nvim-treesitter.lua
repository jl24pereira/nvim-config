return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- esta versión no permite cargarlo después
    build = ":TSUpdate",
    config = function()
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
        if not vim.env.PATH:find(mason_bin, 1, true) then
            vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
        end
        -- Analizadores que queremos instalados
        require("nvim-treesitter").install({
            "java", "lua", "vim", "vimdoc", "query",
            "markdown", "markdown_inline",
            "groovy", "yaml", "xml", "properties",
            "json", "json5", "dockerfile", "bash", "toml", "c",
        })

        -- En esta versión hay que encender los colores e indentación en cada archivo
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if pcall(vim.treesitter.start, args.buf) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
