local home = os.getenv("USERPROFILE")
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"
local path_to_jar = vim.fn.glob(path_to_plugins .. "org.eclipse.equinox.launcher_*.jar")
local path_to_config = jdtls_path .. "/config_win"

-- 1. Detección de la raíz del proyecto
local root_markers = { ".git", "mvnw", "gradlew", "build.gradle", "pom.xml" }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == "" then
    root_dir = vim.fn.getcwd()
end

-- 2. Carpeta de datos del Workspace (Caché)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/AppData/Local/temp/jdtls-workspace/" .. project_name

-- 3. Configuración completa del servidor
local config = {
  cmd = {
    "java", 
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    "-jar", path_to_jar,
    "-configuration", path_to_config,
    "-data", workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = "C:/Program Files/Java/jdk-21", -- Ruta al JDK 21
            default = true,
          },
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}