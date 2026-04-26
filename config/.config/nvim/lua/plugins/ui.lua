-- ─────────────────────────────────────────────
--  plugins/ui.lua  –  Visual / UI plugins (VSCode-style)
-- ─────────────────────────────────────────────

return {
  -- ── Colorscheme: Catppuccin (VSCode-like dark) ──
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    lazy     = false,
    opts = {
      flavour          = "mocha",
      transparent_background = false,
      term_colors      = true,
      integrations     = {
        nvimtree    = true,
        telescope   = true,
        bufferline  = true,
        cmp         = true,
        treesitter  = true,
        gitsigns    = true,
        which_key   = true,
        indent_blankline = { enabled = true },
        native_lsp  = { enabled = true },
        mason       = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Statusline ────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "catppuccin-mocha",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        -- Middle-left section (file info)
        lualine_b = {
          { "branch", icon = "", color = { fg = "#a6da95" } },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = true,
          },
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            diagnostics_color = {
              error = { fg = "#f38181" },
              warn  = { fg = "#eed49f" },
              info  = { fg = "#8087a2" },
              hint  = { fg = "#91d7e3" },
            },
          },
        },
        -- Center section (filename)
        lualine_c = {
          { "filename", path = 1, file_status = true, symbols = { modified = " ●", readonly = " 🔒", unnamed = "[No Name]" } },
        },
        -- Middle-right section (LSP servers)
        lualine_x = {
          {
            function()
            local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
            if #buf_clients == 0 then
              return "󰚌 No LSP"
              end
              local client_names = {}
              for _, client in ipairs(buf_clients) do
                table.insert(client_names, client.name)
                end
                return "󰒡 " .. table.concat(client_names, ", ")
                end,
                color = { fg = "#c6a0f6" },
                cond = function()
                return vim.fn.mode() ~= "c"
                end,
          },
          {
            "encoding",
            fmt = string.upper,
            color = { fg = "#8087a2" },
            cond = function()
            return vim.fn.strlen(vim.o.fileencoding) > 0
            end,
          },
          {
            "fileformat",
            fmt = string.upper,
            symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            color = { fg = "#8087a2" },
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },

      -- Inactive window statusline
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      -- Tabline (shows open buffers like VSCode)
      tabline = {},
      extensions = { "nvim-tree", "trouble", "fzf", "quickfix" },
    },
  },

  -- ── BufferLine (tabs like VSCode) ────────────
  {
    "akinsho/bufferline.nvim",
    event        = "BufAdd",
    version      = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
    opts = {
      options = {
        mode              = "buffers",
        numbers           = "none",
        close_command     = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        diagnostics       = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " ", hint = "󰌵 " }
          local s = {}
          for k, n in pairs(diag) do
            if icons[k] then table.insert(s, icons[k] .. n) end
          end
          return table.concat(s, " ")
        end,
        offsets = {
          { filetype = "NvimTree", text = "  Explorer", text_align = "left", separator = true }
        },
        show_buffer_close_icons = true,
        show_close_icon         = false,
        separator_style         = "slant",
        always_show_bufferline  = true,  -- CHANGED: Always show tabs (like VSCode)
      },
    },
    -- ── VSCode-style buffer navigation ────────────
    config = function(_, opts)
      require("bufferline").setup(opts)
      
      local map = vim.keymap.set
      -- Switch buffers with Ctrl+Tab / Ctrl+Shift+Tab (VSCode style)
      map("n", "<C-Tab>",       "<cmd>BufferLineCycleNext<CR>",     { noremap = true, silent = true })
      map("n", "<C-S-Tab>",     "<cmd>BufferLineCyclePrev<CR>",     { noremap = true, silent = true })
      
      -- Or use Alt+1, Alt+2, etc to jump to specific tabs
      for i = 1, 9 do
        map("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { noremap = true, silent = true })
      end
      
      -- Close buffer with Ctrl+W
      map("n", "<C-w>",         "<cmd>Bdelete<CR>",                { noremap = true, silent = true })
    end,
  },

  -- ── File Explorer (sidebar) ───────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd          = { "NvimTreeToggle", "NvimTreeFocus" },
    keys         = { 
      { "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle Sidebar" }
    },
    opts = {
      disable_netrw  = true,
      hijack_netrw   = true,
      view           = { width = 32, side = "left" },
      renderer = {
        group_empty    = true,
        highlight_git  = true,
        icons = {
          glyphs = {
            default  = "",
            symlink  = "",
                -- folder line REMOVED - let NvimTree use defaults
            git      = { unstaged = "✗", staged = "✓", unmerged = "", renamed = "➜", untracked = "★", deleted = "", ignored = "◌" },
          },
        },
      },
      filters        = { dotfiles = false },
      git            = { enable = true, ignore = false },
      actions        = { open_file = { quit_on_open = false, window_picker = { enable = true } } },
      update_focused_file = { enable = true },
    },
  },

  -- ── Icons ─────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ── Indent guides ─────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main  = "ibl",
    opts  = {
      indent    = { char = "│" },
      scope     = { enabled = true, show_start = true },
    },
  },

  -- ── Color column / rainbow delimiters ─────────
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },

  -- ── Notifications ─────────────────────────────
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      local notify = require("notify")
      notify.setup({ stages = "fade_in_slide_out", timeout = 2500, max_width = 60 })
      vim.notify = notify
    end,
  },

  -- ── Which-key (keybinding hints) ──────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      preset = "modern",
      icons  = { mappings = true },
      spec   = {
        { "<leader>f",  group = "Find/Files" },
        { "<leader>l",  group = "LSP" },
        { "<leader>g",  group = "Git" },
        { "<leader>t",  group = "Terminal" },
      },
    },
  },

  -- ── UI polish ─────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
    },
  },

  -- ── Smooth scrolling ─────────────────────────
  { "karb94/neoscroll.nvim", event = "BufReadPost", opts = { mappings = { "<C-u>","<C-d>","<C-b>","<C-f>" } } },

  -- ── Dashboard ─────────────────────────────────
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha   = require("alpha")
      local dash    = require("alpha.themes.dashboard")
      dash.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
      }
      dash.section.buttons.val = {
        dash.button("Ctrl+P", "  Find File",    "<cmd>Telescope find_files<CR>"),
        dash.button("e",      "  New File",     "<cmd>enew<CR>"),
        dash.button("r",      "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
        dash.button("s",      "  Settings",     "<cmd>e $MYVIMRC<CR>"),
        dash.button("q",      "  Quit",         "<cmd>qa<CR>"),
      }
      alpha.setup(dash.opts)
    end,
  },
}
