return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    config = function()
        local manager = require("neo-tree.sources.manager")
        local old_get_state = manager.get_state
        manager.get_state = function(source_name, tabnr)
            if not source_name then
                return {}
            end
            return old_get_state(source_name, tabnr)
        end

        require("neo-tree").setup({
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true
                },
                use_libuv_file_watcher = true
            },
            window = {
                mappings = {
                    ["<space>"] = "none" -- Para que no interfiera con tu tecla Leader
                }
            },
            source_selector = {
                winbar = false,
                statusline = false
            }
        })
    end
}