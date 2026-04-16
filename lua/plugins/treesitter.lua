return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = 'VeryLazy',
    config = function()
        vim.env.CC = "clang"
        require("nvim-treesitter.install").compilers = {"clang"}

        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then return end

        configs.setup({
            ensure_installed = {"c", "lua", "java", "markdown"},
            highlight = {enable = true},
            indent = {enable = true},
            auto_install = true
        })
    end
}
