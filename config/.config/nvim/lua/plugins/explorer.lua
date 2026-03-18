-- ============================================================
--  plugins/explorer.lua — File explorer (VSCode sidebar feel)
--  Note: netrw is disabled in config/options.lua
-- ============================================================

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      {
        "<C-e>",
        function()
          local api  = require("nvim-tree.api")
          local view = require("nvim-tree.view")
          if view.is_visible() then
            api.tree.close()
          else
            api.tree.open()
            vim.cmd("wincmd p")   -- return focus to editor
          end
        end,
        desc = "Toggle file explorer",
      },
    },
    config = function()
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
            git_placement = "after",
            show = {
              file         = true,
              folder       = true,
              folder_arrow = true,
              git          = true,
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
