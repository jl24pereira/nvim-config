-- JDTLS (Java LSP) configuration
-- Este archivo es la ÚNICA fuente de arranque de jdtls.
-- Neovim lo carga automáticamente al abrir cualquier archivo .java

local jdtls = require("jdtls")
local home  = os.getenv("HOME")
local mason = vim.fn.stdpath("data") .. "/mason"

-- ─────────────────────────────────────────────────────────────────────
-- ROOT_DIR PARA PROYECTOS GRADLE MULTI-MÓDULO
-- Primero settings.gradle (raíz del multi-módulo); si no, gradlew/mvnw/.git
-- ─────────────────────────────────────────────────────────────────────
local function find_project_root()
    local root = require("jdtls.setup").find_root({ "settings.gradle", "settings.gradle.kts" })
    if not root then
        root = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git" })
    end
    return root
end

local root_dir = find_project_root()
if not root_dir then return end -- No hay proyecto válido: no iniciar jdtls

-- Workspace único por proyecto (usa la ruta completa, no solo el nombre de la carpeta)
local workspace_dir = home .. "/jdtls-workspace/" .. root_dir:gsub("^/", ""):gsub("/", "_")

-- ─────────────────────────────────────────────────────────────────────
-- BUNDLES (extensiones de jdtls)
-- ─────────────────────────────────────────────────────────────────────
-- 1. Java Debug Adapter
local bundles = {
    vim.fn.glob(mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- 2. Java Test (sin los jars que no son extensiones de jdtls)
local excluded = {
    "com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "jacocoagent.jar",
}
for _, jar in ipairs(vim.split(vim.fn.glob(mason .. "/share/java-test/*.jar"), "\n")) do
    if jar ~= "" and not vim.tbl_contains(excluded, vim.fn.fnamemodify(jar, ":t")) then
        table.insert(bundles, jar)
    end
end

-- ─────────────────────────────────────────────────────────────────────
-- CONFIGURACIÓN JDTLS
-- ─────────────────────────────────────────────────────────────────────
local java_home = home .. "/.sdkman/candidates/java/current"

local config = {
    cmd          = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", mason .. "/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
        "-configuration", mason .. "/packages/jdtls/config_linux",
        "-data", workspace_dir,
    },

    root_dir     = root_dir,

    settings     = {
        java = {
            eclipse                 = { downloadSources = true },
            maven                   = { downloadSources = true },
            configuration           = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    { name = "JavaSE-21", path = java_home },
                },
            },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens      = { enabled = true },
            references              = { includeDecompiledSources = true },
            signatureHelp           = { enabled = true },
            format                  = {
                enabled = true,
                settings = {
                    url     = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            completion              = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                importOrder = { "java", "javax", "com", "org" },
            },
            sources                 = {
                organizeImports = {
                    starThreshold       = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration          = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
            },
        },
    },

    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    flags        = { allow_incremental_sync = true },

    init_options = {
        bundles                    = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },

    on_attach    = function(_, _)
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
    end,
}

-- start_or_attach ya reutiliza el cliente si el proyecto ya tiene jdtls corriendo
jdtls.start_or_attach(config)
