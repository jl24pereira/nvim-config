-- JDTLS (Java LSP) configuration
-- Este archivo es la ÚNICA fuente de arranque de jdtls.
-- Neovim lo carga automáticamente al abrir cualquier archivo .java

local home = os.getenv("HOME")
local jdtls = require("jdtls")

-- Busca la raíz real del proyecto multi-módulo Gradle
-- Sube hasta encontrar settings.gradle (raíz del proyecto completo)
-- y no se detiene en build.gradle de un submódulo
local function find_gradle_root()
    -- Primero intenta encontrar settings.gradle (raíz multi-módulo)
    local root = require("jdtls.setup").find_root({
        "settings.gradle",
        "settings.gradle.kts",
    })

    -- Si no hay settings.gradle, busca indicadores alternativos de raíz
    if not root then
        root = require("jdtls.setup").find_root({
            "mvnw",
            "gradlew", -- gradlew en raíz es buen indicador
            ".git",
        })
    end

    return root
end

local root_dir = find_gradle_root()
-- Si no hay proyecto válido, no iniciar nada
if not root_dir then return end

-- Guard: si ya hay un cliente jdtls activo para este root_dir, solo hacer attach y salir
for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "jdtls" and client.config.root_dir == root_dir then
        vim.lsp.buf_attach_client(0, client.id)
        return
    end
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local system_os = ""
if vim.fn.has("mac") == 1 then
    system_os = "mac"
elseif vim.fn.has("unix") == 1 then
    system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    system_os = "win"
else
    system_os = "linux"
end

-- ─────────────────────────────────────────────────────────────────────
-- BUNDLES
-- ─────────────────────────────────────────────────────────────────────

-- 1. Java Debug Adapter
local bundles = {
    vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar")
}

-- 2. Java Test (JUnit runner desde jdtls)
vim.list_extend(bundles, vim.split(
    vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"
))

-- 3. Spring Boot Tools
--    Ruta real: ~/.local/share/nvim/mason/packages/vscode-spring-boot-tools/extension/language-server/lib/
local spring_ls_lib = home .. "/.local/share/nvim/mason/packages/vscode-spring-boot-tools/extension/language-server/lib"

-- Solo añadir si el paquete está instalado
local spring_jars = vim.fn.glob(spring_ls_lib .. "/*.jar", 1)
if spring_jars ~= "" then
    vim.list_extend(bundles, vim.split(spring_jars, "\n"))
end

-- ─────────────────────────────────────────────────────────────────────
-- CONFIGURACIÓN JDTLS
-- ─────────────────────────────────────────────────────────────────────
local config = {
    cmd          = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
        "-configuration", home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. system_os,
        "-data", workspace_dir,
    },

    root_dir     = root_dir,

    settings     = {
        java = {
            home                    = "/home/jlpereira/.sdkman/candidates/java/current",
            eclipse                 = { downloadSources = true },
            configuration           = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "/home/jlpereira/.sdkman/candidates/java/current"
                    }
                }
            },
            maven                   = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens      = { enabled = true },
            references              = { includeDecompiledSources = true },
            signatureHelp           = { enabled = true },
            format                  = {
                enabled = true,
                settings = {
                    url     = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
                    profile = "GoogleStyle"
                }
            },
            completion              = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                importOrder = { "java", "javax", "com", "org" }
            },
            sources                 = {
                organizeImports = {
                    starThreshold       = 9999,
                    staticStarThreshold = 9999
                }
            },
            codeGeneration          = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                useBlocks = true
            },
            boot                    = {
                support = { enabled = true }
            }
        }
    },

    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    flags        = { allow_incremental_sync = true },

    init_options = {
        bundles                    = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },

    on_attach    = function(client, bufnr)
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
    end
}

jdtls.start_or_attach(config)
