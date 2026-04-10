return {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            handlers = {function(server_name)
                require("lspconfig")[server_name].setup({})
            end}
        })
    end
}
