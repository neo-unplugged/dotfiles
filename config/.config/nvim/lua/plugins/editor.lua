-- ============================================================
--  plugins/editor.lua — Editor experience (search, git, QoL)
-- ============================================================

return {

  -- ── Telescope ─────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    version      = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        -- only load if the build actually produced the shared lib
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix   = "   ",
          selection_caret = " ",
          border          = true,
          borderchars     = { "─","│","─","│","╭","╮","╯","╰" },
          layout_config   = { horizontal = { preview_width = 0.55 } },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
          mappings = {
            i = {
              ["<C-n>"]    = actions.cycle_history_next,
              ["<C-p>"]    = actions.cycle_history_prev,
              ["<Esc>"]    = actions.close,
              ["<CR>"]     = actions.select_default,
              ["<C-x>"]    = actions.select_horizontal,
              ["<C-v>"]    = actions.select_vertical,
              ["<C-q>"]    = actions.send_to_qflist + actions.open_qflist,
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
            require("telescope.themes").get_dropdown(),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- pcall so a missing native build doesn't crash telescope entirely
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },

  -- ── Git (Neogit + Gitsigns + Diffview) ────────────────────
  {
    "NeogitOrg/neogit",
    cmd          = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = { integrations = { diffview = true } },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay         = 500,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {},
  },

  -- ── ToggleTerm (VSCode integrated terminal) ───────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys    = { "<C-`>" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping    = [[<C-`>]],
      hide_numbers    = true,
      direction       = "horizontal",
      close_on_exit   = true,
      shell           = vim.o.shell,
      float_opts      = { border = "curved" },
    },
  },

  -- ── Autopairs ────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = {
      check_ts         = true,        -- use treesitter
      ts_config        = { lua = { "string" }, javascript = { "template_string" } },
      fast_wrap        = {
        map    = "<M-e>",
        chars  = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        offset  = 0,
        end_key = "$",
        keys    = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma  = true,
        highlight     = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)
      -- Hook autopairs into cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Comment.nvim (Ctrl+/ handled here) ───────────────────
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<C-/>", function() require("Comment.api").toggle.linewise.current() end,
        desc = "Toggle comment", mode = { "n", "i" } },
      { "<C-/>", '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        desc = "Toggle comment", mode = "v" },
      { "gcc", mode = "n", desc = "Comment line" },
      { "gc",  mode = "v", desc = "Comment selection" },
    },
    opts = {},
  },

  -- ── Multi-cursor (Ctrl+D) ─────────────────────────────────
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-d>", mode = { "n", "v" }, desc = "Multi-cursor select word" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
    end,
  },

  -- ── Surround ──────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    event   = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts    = {},
  },

  -- ── Flash (better f/t/s navigation) ──────────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
    keys  = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,             desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end,  desc = "Treesitter Search" },
      { "<C-s>", mode = "c",               function() require("flash").toggle() end,             desc = "Toggle Flash Search" },
    },
  },

  -- ── Todo comments (VSCode TODO highlight) ─────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Search TODOs" },
    },
  },

  -- ── Trouble (VSCode problems panel) ──────────────────────
  {
    "folke/trouble.nvim",
    cmd  = { "Trouble", "TroubleToggle" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                    desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",       desc = "Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>",            desc = "Symbols (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                         desc = "Quickfix List" },
    },
  },

  -- ── Session persistence ───────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end,  desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Session" },
    },
  },

  -- ── Auto dim inactive windows (like VSCode inactive panes) ─
  {
    "levouh/tint.nvim",
    event = "VeryLazy",
    opts  = { tint = -30, saturation = 0.7 },
  },

  -- ── Smooth scroll ─────────────────────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic",
        -- Exclude <C-e> and <C-y> so file explorer / redo keymaps work
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      })
    end,
  },

  -- ── Color highlighter (#hex colors shown inline) ──────────
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts  = { user_default_options = { tailwind = true } },
  },

  -- ── Smart buffer delete (never exits Neovim) ─────────────
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>bd", function() require("bufdelete").bufdelete(0, false) end, desc = "Close buffer" },
      { "<leader>bD", function() require("bufdelete").bufdelete(0, true)  end, desc = "Force close buffer" },
    },
  },

}
