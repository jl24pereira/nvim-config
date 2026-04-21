-- nvim-jdtls: solo declara el plugin como dependencia.
-- Todo el arranque de jdtls ocurre EXCLUSIVAMENTE en ftplugin/java.lua
return {
    "mfussenegger/nvim-jdtls",
    ft = "java", -- lazy.nvim lo carga al abrir un .java, luego ftplugin/java.lua toma el control
}
