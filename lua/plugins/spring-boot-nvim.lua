return {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {
        -- Solo arrancar en proyectos que realmente usan Spring Boot
        project_filter = function(root_dir)
            return require("spring_boot.util").has_spring_boot_dependency(root_dir)
        end,
    },
    keys = {
        { "<leader>js", "<cmd>SpringBoot<cr>",                 desc = "Spring: Buscar (menú)" },
        { "<leader>jb", "<cmd>SpringBoot Beans<cr>",           desc = "Spring: Beans" },
        { "<leader>jr", "<cmd>SpringBoot RequestMappings<cr>", desc = "Spring: Endpoints" },
    },
}
