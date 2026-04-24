local function battery()
    -- Verificar que acpi existe
    if vim.fn.executable("acpi") == 0 then return "" end

    local handle = io.popen("acpi -b 2>/dev/null")
    if not handle then return "" end
    local output = handle:read("*a")
    handle:close()

    -- Si no hay batería o acpi no devuelve datos, no mostrar nada
    if not output or output == "" then return "" end

    local percent = output:match("(%d+)%%")
    if not percent then return "" end

    local p = tonumber(percent)
    local icon

    if p >= 90 then
        icon = " "
    elseif p >= 65 then
        icon = " "
    elseif p >= 40 then
        icon = " "
    elseif p >= 20 then
        icon = " "
    else
        icon = " "
    end

    return icon .. percent .. "%%"
end
return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim'
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
            },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = {
                {
                    -- Customize the filename part of lualine to be parent/filename
                    'filename',
                    file_status = true,     -- Displays file status (readonly status, modified status)
                    newfile_status = false, -- Display new file status (new file means no write after created)
                    path = 4,               -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory
                    symbols = {
                        modified = '[+]', -- Text to show when the file is modified.
                        readonly = '[-]'  -- Text to show when the file is non-modifiable or readonly.
                    }
                }
            },
            lualine_x = { 'encoding', 'fileformat', 'filetype', },
            lualine_y = { 'progress' },
            lualine_z = {
                'location',
                {
                    function()
                        return os.date("󱑎 %H:%M:%S")
                    end
                },
                battery,
            }
        }
    }
}
