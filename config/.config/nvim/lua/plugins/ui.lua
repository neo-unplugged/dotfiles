-- ============================================================
--  plugins/ui.lua — VSCode-like UI chrome
-- ============================================================

return {

  -- ── Statusline (lualine) ──────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "tokyonight",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
      },
    },
  },

  -- ── Bufferline (VSCode tabs) ──────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event        = "VeryLazy",
    version      = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode                    = "buffers",
        diagnostics             = "nvim_lsp",
        separator_style         = "slant",
        show_buffer_close_icons = true,
        show_close_icon         = false,
        always_show_bufferline  = true,
        offsets = {
          {
            filetype  = "NvimTree",
            text      = "  Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- ── File Explorer (nvim-tree) ─────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    cmd          = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_netrw        = true,
      sync_root_with_cwd  = true,
      respect_buf_cwd     = true,
      update_focused_file = { enable = true },
      view = { width = 35, side = "left" },
      renderer = {
        group_empty = true,
        icons = {
          glyphs = {
            default = "",
            symlink = "",
            folder  = {
              arrow_closed = "",
              arrow_open   = "",
              default      = "󰉋",
              open         = "󰝰",
              empty        = "󰉖",
              empty_open   = "󰷏",
              symlink      = "󰉒",
              symlink_open = "󰉒",
            },
            git = {
              unstaged  = "✗",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "★",
              deleted   = "",
              ignored   = "◌",
            },
          },
        },
      },
      filters     = { dotfiles = false },
      git         = { enable = true, ignore = false },
      -- diagnostics intentionally disabled — sign-based renderer is broken
      -- in current nvim-tree; use lsp inline diagnostics instead
      diagnostics = { enable = false },
    },
  },

  -- ── Indent guides ─────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main  = "ibl",
    opts  = {
      indent = { char = "│" },
      scope  = { enabled = true, show_start = false },
    },
  },

  -- ── Breadcrumbs / winbar ──────────────────────────────────
  {
    "utilyre/barbecue.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    version      = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = { theme = "tokyonight" },
  },

  -- ── Notifications ─────────────────────────────────────────
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
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
        inc_rename            = false,
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
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "",
        },
        center = {
          { icon = "  ", key = "n", desc = "New File",        action = "enew" },
          { icon = "  ", key = "p", desc = "Find File",       action = "Telescope find_files" },
          { icon = "  ", key = "r", desc = "Recent Files",    action = "Telescope oldfiles" },
          { icon = "  ", key = "g", desc = "Live Grep",       action = "Telescope live_grep" },
          { icon = "  ", key = "s", desc = "Restore Session", action = "lua require('persistence').load()" },
          { icon = "  ", key = "l", desc = "Lazy",            action = "Lazy" },
          { icon = "  ", key = "q", desc = "Quit",            action = "qa" },
        },
        footer = { "", "  Neovim — fast. modal. yours." },
      },
    },
  },

  -- ── Which-key v3 ─────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event   = "VeryLazy",
    version = "*",
    opts    = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>q", group = "session" },
        { "<leader>b", group = "buffer" },
        { "g",         group = "goto" },
        { "]",         group = "next" },
        { "[",         group = "prev" },
      })
    end,
  },

}
