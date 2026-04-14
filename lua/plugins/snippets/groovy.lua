local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return { -- Plantilla Base Spring Boot
    s("bootbuild", {
        t({
            "plugins {", "    id 'java'",
            "    id 'org.springframework.boot' version '"
        }), i(1, "3.2.2"),
        t({"'", "    id 'io.spring.dependency-management' version '"}),
        i(2, "1.1.4"), t({"'", "}", "", "group = '"}), i(3, "com.tu.paquete"),
        t({"'", "version = '"}), i(4, "0.0.1-SNAPSHOT"),
        t({"'", "", "java {", "    sourceCompatibility = '"}), i(5, "17"), t({
            "'", "}", "", "repositories {", "    mavenCentral()", "}", "",
            "dependencies {",
            "    implementation 'org.springframework.boot:spring-boot-starter-web'",
            "    testImplementation 'org.springframework.boot:spring-boot-starter-test'",
            "    "
        }), i(0),
        t({"", "}", "", "tasks.named('test') {", "    useJUnitPlatform()", "}"})
    }), -- Dependencia API (Librerías compartidas)
    s("depapi", {
        t({"api '"}), i(1, "grupo"), t({":"}), i(2, "artefacto"), t({":"}),
        i(3, "version"), t({"'", ""}), i(0)
    }), -- Dependencia Implementation
    s("depimpl", {
        t({"implementation '"}), i(1, "org.springframework.boot"), t({":"}),
        i(2, "spring-boot-starter-data-jpa"), t({"'", ""}), i(0)
    }), -- Dependencia Test
    s("deptest", {
        t({"testImplementation '"}), i(1, "org.junit.jupiter"), t({":"}),
        i(2, "junit-jupiter-api"), t({"'", ""}), i(0)
    }), -- Dependencia de Proyecto (Multi-módulo)
    s("depproj", {
        t({"implementation project(':"}), i(1, "nombre-del-modulo"), t({"') "}),
        i(0)
    }), -- Configuración de Submódulos (allprojects)
    s("allprojects", {
        t({"allprojects {", "    group = '"}), i(1, "com.tu.paquete"),
        t({"'", "    version = '"}), i(2, "0.0.1-SNAPSHOT"), t({
            "'", "", "    repositories {", "        mavenCentral()", "    }",
            "}", "", "subprojects {", "    apply plugin: 'java'",
            "    apply plugin: 'io.spring.dependency-management'", "",
            "    dependencies {", "        "
        }), i(0), t({"", "    }", "}"})
    })
}
