-- ============================================================
--  plugins/colorscheme.lua — TokyoNight (VSCode Dark+ vibes)
-- ============================================================

return {
  {
    "folke/tokyonight.nvim",
    lazy    = false,
    priority = 1000,
    opts = {
      style       = "night",   -- night | storm | day | moon
      transparent = false,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        functions = {},
        variables = {},
        sidebars  = "dark",
        floats    = "dark",
      },
      on_highlights = function(hl, c)
        -- Make the active line number pop like VSCode
        hl.CursorLineNr = { fg = c.yellow, bold = true }
        -- Slightly brighter indent lines
        hl.IndentBlanklineChar = { fg = c.dark3 }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
