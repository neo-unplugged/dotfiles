-- ============================================================
--  plugins/explorer.lua — File explorer (VSCode sidebar feel)
-- ============================================================

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- Must disable netrw BEFORE nvim-tree loads
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        hijack_netrw       = true,
        hijack_cursor      = true,
        sync_root_with_cwd = true,
        view = {
          width = 35,
          side  = "left",
          preserve_window_proportions = true,
        },
        renderer = {
          group_empty       = true,
          highlight_git     = true,
          root_folder_label = ":~:s?$?/..?",
          indent_markers    = { enable = true },
          icons = {
            web_devicons = {
              file   = { enable = true, color = true },
              folder = { enable = true, color = true },
            },
            git_placement  = "after",
            show = {
              file        = true,
              folder      = true,
              folder_arrow = true,
              git         = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          custom   = { ".DS_Store", "node_modules", ".git" },
        },
        git = {
          enable  = true,
          ignore  = false,
          timeout = 400,
        },
        actions = {
          open_file = {
            quit_on_open  = false,
            resize_window = true,
            window_picker = { enable = false },
          },
        },
        diagnostics = {
          enable       = true,
          show_on_dirs = true,
        },
      })
    end,
  },
}
