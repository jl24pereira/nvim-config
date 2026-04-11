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
            close_if_last_window = true,
            popup_border_style = "rounded",
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true
                },
                use_libuv_file_watcher = true
            },
            window = {
                position = "left",
                width = 40,
                mappings = {
                    ["<space>"] = "none" -- Para que no interfiera con tu tecla Leader
                }
            },
            source_selector = {
                winbar = true,
                statusline = false,
                content_layout = "center",
                sources = {
                    { source = "filesystem", display_name = " 󰉓 Files " },
                    { source = "buffers", display_name = " 󰈙 Buffers " },
                    { source = "git_status", display_name = " 󰊢 Git " },
                }
            },
            enable_git_status = true,
            enable_diagnostics = true,

        })
    end
}
