-- Archivo: ftplugin/java.lua
-- Versión blindada para Windows y manejo de errores

local status, jdtls = pcall(require, "jdtls")
if not status then
    vim.notify("ERROR: El plugin nvim-jdtls no está instalado o cargado", vim.log.levels.ERROR)
    return
end

-- 1. Ruta absoluta al ejecutable de Mason (A prueba de fallos de PATH en Windows)
local jdtls_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls.cmd"

-- 2. Cálculo del workspace único
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name

-- 3. Detección segura de la raíz del proyecto (Evita crashes si no detecta .git o gradle)
local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'build.gradle'})
if root_dir == "" or root_dir == nil then
    root_dir = vim.fn.getcwd() -- Si falla, usa la carpeta actual como rescate
end

-- 4. Configuración Maestra
local config = {
    cmd = { jdtls_path },
    root_dir = root_dir,
    
    settings = {
        java = {
            signatureHelp = { enabled = true },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "C:/Program Files/Java/jdk-21",
                        default = true,
                    }
                }
            }
        }
    },
    
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    
    init_options = {
        workspace = workspace_dir
    }
}

-- 5. Arranque con escudo de errores (pcall)
local success, err = pcall(function()
    jdtls.start_or_attach(config)
end)

-- Si el servidor se estrella, nos mostrará el mensaje exacto en rojo en lugar de ocultarlo
if not success then
    vim.notify("FATAL JDTLS ERROR: " .. tostring(err), vim.log.levels.ERROR)
end