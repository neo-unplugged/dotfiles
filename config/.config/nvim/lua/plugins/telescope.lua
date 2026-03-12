-- ============================================================
--  plugins/telescope.lua — Fuzzy finder (VSCode Ctrl+P feel)
-- ============================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix    = "  ",      -- VSCode-style search icon
          selection_caret  = " ",
          path_display     = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width   = 0.55,
              results_width   = 0.8,
            },
            vertical = { mirror = false },
            width         = 0.87,
            height        = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"]     = actions.move_selection_next,
              ["<C-k>"]     = actions.move_selection_previous,
              ["<C-c>"]     = actions.close,
              ["<Esc>"]     = actions.close,
              ["<CR>"]      = actions.select_default,
              ["<C-s>"]     = actions.select_horizontal,
              ["<C-v>"]     = actions.select_vertical,
              ["<C-t>"]     = actions.select_tab,
              ["<C-u>"]     = actions.preview_scrolling_up,
              ["<C-d>"]     = actions.preview_scrolling_down,
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "dist/", "build/",
            "%.lock", "%.jpeg", "%.jpg", "%.png", "%.gif",
          },
        },
        pickers = {
          find_files = {
            hidden      = true,   -- Show hidden files
            follow      = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused    = true,
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}
