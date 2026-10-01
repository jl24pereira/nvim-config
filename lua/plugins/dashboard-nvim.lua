return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup {
            -- config
            theme = 'hyper',
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        desc = ' Proyectos',
                        group = 'DiagnosticHint',
                        action = 'Telescope projects',
                        key = 'p',
                    },
                    {
                        desc = ' Config nvim',
                        group = 'Number',
                        action = function()
                            require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
                        end,
                        key = 'c',
                    },
                },
            },
        }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
