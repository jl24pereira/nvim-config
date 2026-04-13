local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- =====================================================================
-- FUNCIONES DINÁMICAS (No tocar)
-- =====================================================================
local get_package = function()
    local path = vim.fn.expand("%:p"):gsub("\\", "/")
    local package_match = path:match("src/main/java/(.+)%.java") or
                              path:match("src/test/java/(.+)%.java")
    if package_match then
        local package_dir = package_match:match("(.*)/")
        if package_dir then
            return "package " .. package_dir:gsub("/", ".") .. ";"
        end
    end
    return ""
end

local get_filename = function() return vim.fn.expand("%:t:r") end

-- =====================================================================
-- COLECCIÓN DE SNIPPETS
-- =====================================================================
return {

    -- ==========================================
    -- 1. CORE JAVA
    -- ==========================================

    s("class", {
        f(get_package, {}), t({"", "", "/**", " * "}),
        i(1, "Descripción de la responsabilidad de esta clase..."),
        t({"", " *", " * @author "}), i(2, "Jose Luis Pereira"),
        t({"", " */", "public class "}), f(get_filename, {}),
        t({" {", "", "    "}), i(0), t({"", "}"})
    }), s("interface", {
        f(get_package, {}), t({"", "", "/**", " * "}),
        i(1, "Descripción del contrato..."), t({"", " *", " * @author "}),
        i(2, "Jose Luis Pereira"), t({"", " */", "public interface "}),
        f(get_filename, {}), t({" {", "    "}), i(0), t({"", "}"})
    }), s("enum", {
        f(get_package, {}), t({"", "", "/**", " * "}),
        i(1, "Enumere los tipos..."), t({"", " *", " * @author "}),
        i(2, "Jose Luis Pereira"), t({"", " */", "public enum "}),
        f(get_filename, {}), t({" {", "    "}), i(0), t({"", "}"})
    }), s("record", {
        f(get_package, {}), t({"", "", "/**", " * DTO inmutable para "}),
        i(1, "transferencia de datos..."), t({"", " *", " * @author "}),
        i(2, "Jose Luis Pereira"), t({"", " */", "public record "}),
        f(get_filename, {}), t({"("}), i(2, "String campo"), t({") {", "    "}),
        i(0), t({"", "}"})
    }), -- ==========================================
    -- 2. SPRING BOOT: ARQUITECTURA
    -- ==========================================
    s("rest", {
        f(get_package, {}), t({
            "", "", "import org.springframework.web.bind.annotation.*;",
            "import org.springframework.http.ResponseEntity;", "", "/**",
            " * Controlador REST para "
        }), i(1, "dominio"), t({"", " *", " * @author "}),
        i(2, "Jose Luis Pereira"),
        t({"", " */", "@RestController", "@RequestMapping(\"/api/v1/"}),
        i(2, "recurso"), t({"\")", "public class "}), f(get_filename, {}),
        t({" {", "", "    private final "}), i(3, "Service"),
        t({" service;", "", "    public "}), f(get_filename, {}), t({"( "}),
        i(4, "Service"),
        t(
            {
                " service ) {", "        this.service = service;", "    }", "",
                "    "
            }), i(0), t({"", "}"})
    }), s("service", {
        f(get_package, {}), t({
            "", "", "import org.springframework.stereotype.Service;", "", "/**",
            " * Lógica de negocio para "
        }), i(1, "dominio"), t({"", " *", " * @author "}),
        i(2, "Jose Luis Pereira"), t({"", " */", "@Service", "public class "}),
        f(get_filename, {}), t({" {", "", "    private final "}),
        i(2, "Repository"), t({" repository;", "", "    public "}),
        f(get_filename, {}), t({"( "}), i(3, "Repository"), t({
            " repository ) {", "        this.repository = repository;", "    }",
            "", "    "
        }), i(0), t({"", "}"})
    }), s("repo", {
        f(get_package, {}), t({
            "", "",
            "import org.springframework.data.jpa.repository.JpaRepository;",
            "import org.springframework.stereotype.Repository;", "",
            "@Repository", "public interface "
        }), f(get_filename, {}), t({" extends JpaRepository<"}), i(1, "Entity"),
        t({", "}), i(2, "Long"), t({"> {", "    "}), i(0), t({"", "}"})
    }), s("entity", {
        f(get_package, {}),
        t(
            {
                "", "", "import jakarta.persistence.*;", "", "@Entity",
                "@Table(name = \""
            }), i(1, "nombre_tabla"), t({"\")", "public class "}),
        f(get_filename, {}), t({
            " {", "", "    @Id",
            "    @GeneratedValue(strategy = GenerationType.IDENTITY)",
            "    private "
        }), i(2, "Long"), t({" id;", "", "    "}), i(0), t({"", "}"})
    }), -- ==========================================
    -- 3. SPRING BOOT: MÉTODOS Y UTILERÍAS
    -- ==========================================
    s("get", {
        t({"@GetMapping(\""}), i(1, "/ruta"),
        t({"\")", "public ResponseEntity<"}), i(2, "ResponseDTO"), t({"> "}),
        i(3, "metodo"), t({"() {", "    return ResponseEntity.ok("}), i(0),
        t({");", "}"})
    }), s("post", {
        t({"@PostMapping(\""}), i(1, "/ruta"),
        t({"\")", "public ResponseEntity<"}), i(2, "ResponseDTO"), t({"> "}),
        i(3, "metodo"), t({"(@RequestBody @Valid "}), i(4, "RequestDTO"),
        t(
            {
                " request) {",
                "    return ResponseEntity.status(HttpStatus.CREATED).body("
            }), i(0), t({");", "}"})
    }), s("log", {
        t({
            "private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger("
        }), f(get_filename, {}), t({".class);"})
    }), s("test", {
        t({"@org.junit.jupiter.api.Test", "void "}), i(1, "shouldDoSomething"),
        t({"_when_"}, i(2, "Condition"), t({"() {", "    // Given", "    "}),
          i(0), t({"", "    // When", "", "    // Then", "}"}))
    })
}
