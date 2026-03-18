-- ============================================================
--  plugins/editor.lua — Editor QoL (pairs, comments, etc.)
-- ============================================================

return {
  -- ── TreeSitter: syntax highlighting ──────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build  = ":TSUpdate",
    event  = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter.install").prefer_git = true

      local parsers = {
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "tsx",
        "python", "rust", "go",
        "html", "css", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "bash", "dockerfile",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- ── Auto-pairs ────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event        = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },  -- ensure cmp loads first
    opts  = {
      fast_wrap = {
        map            = "<M-e>",
        chars          = { "{", "[", "(", '"', "'" },
        pattern        = string.format([=[[%s%%s%s]]=], "%s", "%s"),
        end_key        = "$",
        keys           = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma    = true,
        highlight      = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)
      -- Hook into cmp confirm — guarded in case cmp isn't available
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- ── Comment.nvim: Ctrl+/ style comments ──────────────────
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts  = { padding = true, sticky = true },
    config = function(_, opts)
      require("Comment").setup(opts)
      local api = require("Comment.api")
      vim.keymap.set("n", "<C-/>", api.toggle.linewise.current,
        { desc = "Toggle comment" })
      vim.keymap.set("v", "<C-/>", function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = "Toggle comment (visual)" })
    end,
  },

  -- ── nvim-surround ─────────────────────────────────────────
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

  -- ── Multi-cursor (Ctrl+D) ─────────────────────────────────
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init  = function()
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Select All"]         = "<C-S-l>",
        ["Add Cursor Down"]    = "<C-S-Down>",
        ["Add Cursor Up"]      = "<C-S-Up>",
      }
      vim.g.VM_theme = "codedark"
    end,
  },

  -- ── Toggleterm: integrated terminal ──────────────────────
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-`>" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping    = [[<C-`>]],
      direction       = "horizontal",
      shade_terminals = true,
      shading_factor  = 2,
      start_in_insert = true,
      persist_mode    = true,
      close_on_exit   = true,
      shell           = vim.o.shell,
      float_opts      = { border = "curved" },
    },
  },

  -- ── Trouble: diagnostics panel ───────────────────────────
  {
    "folke/trouble.nvim",
    cmd          = { "Trouble", "TroubleToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts         = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",    desc = "Toggle diagnostics panel" },
      { "<leader>xd", "<cmd>Trouble lsp_definitions toggle<CR>", desc = "LSP definitions" },
    },
  },

  -- ── Hop: fast navigation ─────────────────────────────────
  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    opts  = { keys = "etovxqpdygfblzhckisuran" },
    keys  = {
      { "<leader>hw", "<cmd>HopWord<CR>",      desc = "Hop to word" },
      { "<leader>hl", "<cmd>HopLineStart<CR>", desc = "Hop to line" },
    },
  },

  -- ── Colorizer: inline color preview ──────────────────────
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB    = true, RRGGBB = true,
        names  = true, css   = true, css_fn = true,
      })
    end,
  },

  -- ── Todo-comments ─────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
  },

  -- ── Illuminate: highlight word under cursor ───────────────
  {
    "RRethy/vim-illuminate",
    event  = { "BufReadPre", "BufNewFile" },
    opts   = {
      delay                = 200,
      large_file_cutoff    = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
