return {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
        require('Comment').setup({
            -- El pre_hook intercepta la acción antes de que falle
            pre_hook = function(ctx)
                -- Si detectamos que es un archivo Java...
                if vim.bo.filetype == 'java' then
                    -- ctx.ctype == 1 significa que presionaste 'gcc' (línea)
                    if ctx.ctype == 1 then
                        return '// %s'
                    -- ctx.ctype == 2 significa que presionaste 'gbc' (bloque)
                    else
                        return '/* %s */'
                    end
                end
            end,
        })
    end
}