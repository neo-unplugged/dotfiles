-- ============================================================
--  plugins/ui.lua — UI enhancements (VSCode-like chrome)
-- ============================================================

return {
  -- ── Lualine: VSCode-style statusbar ─────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                 = "tokyonight",
        component_separators  = { left = "", right = "" },
        section_separators    = { left = "", right = "" },
        globalstatus          = true,
        disabled_filetypes    = { statusline = { "NvimTree", "lazy" } },
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },  -- relative path
        lualine_x = {
          { "encoding" },
          { "fileformat" },
          { "filetype", icon_only = false },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Bufferline: VSCode-style tabs ────────────────────────
  {
    "akinsho/bufferline.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
      options = {
        mode                = "buffers",
        style_preset        = bufferline.style_preset.default,
        themable            = true,
        numbers             = "none",
        close_command       = "bdelete! %d",
        diagnostics         = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype   = "NvimTree",
            text       = " Explorer",
            text_align = "left",
            separator  = true,
          },
        },
        color_icons         = true,
        show_buffer_icons   = true,
        show_buffer_close_icons = true,
        show_close_icon     = true,
        show_tab_indicators = true,
        separator_style     = "slant",
        always_show_bufferline = true,
      },
      })
    end,
  },

  -- ── Indent guides (VSCode-style) ─────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {
      indent = {
        char      = "│",
        tab_char  = "│",
      },
      scope = {
        enabled   = true,
        show_start = true,
        show_end   = false,
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "NvimTree",
          "Trouble", "lazy", "mason", "notify",
          "toggleterm", "lazyterm",
        },
      },
    },
  },

  -- ── Noice: VSCode-style command/notification UI ──────────
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      presets = {
        bottom_search        = true,   -- classic bottom search bar
        command_palette      = true,   -- position command palette like VSCode
        long_message_to_split = true,
        inc_rename           = false,
        lsp_doc_border       = true,   -- bordered LSP docs
      },
    },
  },

  -- ── Nvim-notify: VSCode-style notifications ──────────────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout     = 3000,
      max_height  = function() return math.floor(vim.o.lines * 0.75) end,
      max_width   = function() return math.floor(vim.o.columns * 0.75) end,
      on_open     = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      render      = "compact",
      stages      = "fade",
    },
  },

  -- ── Which-key: VSCode keybinding hints popup ─────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      -- v3+ API (window → win, plugins removed)
      win    = { border = "rounded" },
      layout = { align = "center" },
      spec   = {
        { "<leader>g", group = "Git" },
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
        { "<leader>h", group = "Git hunks" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },

  -- ── Dashboard ────────────────────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          "  ██╗  ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ███╗ ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚████║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚███║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "",
        },
        center = {
          { action = "Telescope find_files",    desc = "  Find File",     key = "f" },
          { action = "Telescope oldfiles",       desc = "  Recent Files",  key = "r" },
          { action = "Telescope live_grep",      desc = "  Find Text",     key = "g" },
          { action = function() require("nvim-tree.api").tree.toggle({ focus = false }) end, desc = "  File Explorer", key = "e" },
          { action = "Lazy",                     desc = "  Plugins",       key = "p" },
          { action = "qa",                       desc = "  Quit",          key = "q" },
        },
        footer = { "", "✨ Happy Coding!" },
      },
    },
  },
}
