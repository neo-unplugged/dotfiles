-- ============================================================
--  plugins/colorscheme.lua — VSCode-like Dark+ theme
-- ============================================================

return {
  {
    "folke/tokyonight.nvim",
    lazy    = false,    -- load immediately
    priority = 1000,    -- load before other plugins
    opts = {
      style        = "night",   -- closest to VSCode Dark+
      transparent  = false,
      terminal_colors = true,
      styles = {
        comments   = { italic = true },
        keywords   = { bold   = true },
        functions  = {},
        variables  = {},
        sidebars   = "dark",
        floats     = "dark",
      },
      on_highlights = function(hl, c)
        -- Make the cursor line more like VSCode
        hl.CursorLine = { bg = "#1f2335" }
        -- VSCode-style selection color
        hl.Visual     = { bg = "#264f78" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- Alternative: use the actual VSCode theme
  -- Uncomment below and comment out tokyonight to use it
  -- {
  --   "Mofiqul/vscode.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("vscode").setup({ style = "dark" })
  --     vim.cmd("colorscheme vscode")
  --   end,
  -- },
}
