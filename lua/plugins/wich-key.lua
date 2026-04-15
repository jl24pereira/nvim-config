return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- 1. Usa un 'preset' moderno
    -- Puedes elegir entre "classic", "modern", o "helix". 
    -- "modern" y "helix" suelen verse mucho más elegantes.
    preset = "modern",

    -- 2. Configura la ventana para que sea flotante y centrada
    win = {
      -- Desactiva que el popup no pueda solapar al cursor (para que se centre bien)
      no_overlap = false, 
      
      -- Agrega padding (espacio interno) para que respire, [arriba/abajo, derecha/izquierda]
      padding = { 1, 2 }, 
      
      -- Título y su posición (puedes ocultarlo poniendo title = false)
      title = true,
      title_pos = "center",
      
      -- Borde de la ventana (combina con tus otras ventanas redondeadas)
      border = "rounded",
      
      -- Posición, ancho y alto:
      -- OJO: WhichKey calcula su tamaño basado en el contenido, pero puedes forzar 
      -- su posición aquí (0.5 es el centro de la pantalla).
      col = 0.5,
      row = 0.5,
      
      -- Opciones de Neovim para la ventana (winblend para transparencia)
      wo = {
        winblend = 10, -- 10% de transparencia (opcional)
      },
    },

    -- 3. Diseño interno de las columnas
    layout = {
      width = { min = 20 }, -- Ancho mínimo de las columnas
      spacing = 3,          -- Espacio entre columnas
    },

    -- 4. Íconos y separadores
    icons = {
      breadcrumb = "»", -- Símbolo de la ruta de teclas en la línea de comandos
      separator = "➜", -- Símbolo entre la tecla y su descripción
      group = "+",     -- Símbolo para grupos
      -- Asegúrate de tener los colores activados si usas mini.icons o devicons
      colors = true,   
    },
  }
}