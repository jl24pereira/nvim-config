return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local bufferline = require("bufferline")

        bufferline.setup({
            options = {
                -- ESTÉTICA MODERNA
                style_preset = bufferline.style_preset.default, -- Estilo base
                themeable = true, -- Permite que tu tema (ej. Catppuccin) lo coloree mejor
                separator_style = "slant", -- "slant", "padded_slant", "slope", "thick", "thin"
                indicator = {
                    style = 'icon', -- Cambia 'underline' por 'icon'
                    icon = '▎' -- Un icono delgado y elegante
                },
                always_show_bufferline = true,

                -- COMPORTAMIENTO Y PANELES
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true
                    }
                },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict,
                                                 context)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,

                -- ICONOS (Ocultos para mantenerlo limpio como pediste)
                show_buffer_close_icons = false,
                show_close_icon = false
            }
        })

        -- ATAJOS DE TECLADO (Keymaps)
        -- Usamos < y > en modo normal para navegar
        -- IMPORTANTE: Usualmente < y > se usan para indentar (tabbular). 
        -- Si los remapeas así, podrías perder esa funcionalidad.
        -- Una alternativa muy común es usar <S-h> y <S-l> (Shift+H y Shift+L)

        vim.keymap.set('n', '<', '<Cmd>BufferLineCyclePrev<CR>',
                       {desc = 'Buffer anterior'})
        vim.keymap.set('n', '>', '<Cmd>BufferLineCycleNext<CR>',
                       {desc = 'Buffer siguiente'})

        -- Opcional: Atajo para cerrar el buffer actual rápidamente (muy útil)
        -- vim.keymap.set('n', '<leader>x', '<Cmd>bdelete<CR>', { desc = 'Cerrar Buffer' })
    end
}
