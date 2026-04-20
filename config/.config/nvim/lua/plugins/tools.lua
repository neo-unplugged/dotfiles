-- ─────────────────────────────────────────────
--  plugins/tools.lua  –  DAP, Git UI, extras
-- ─────────────────────────────────────────────

return {
  -- ── DAP (Debug Adapter Protocol) ─────────────
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>",        function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
      { "<F10>",       function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",       function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",       function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db",  function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB",  function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dr",  function() require("dap").repl.open() end,         desc = "Open REPL" },
    },
    dependencies = {
      -- UI
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
      -- Go adapter
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap     = require("dap")
      local dapui   = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"]     = dapui.close

      -- UI toggle
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

      -- ── Go debugger (delve) ───────────────────
      require("dap-go").setup()

      -- ── C/C++ / Rust debugger (lldb) ─────────
      dap.adapters.lldb = {
        type    = "executable",
        command = "/usr/bin/lldb-vscode",   -- adjust to your lldb path
        name    = "lldb",
      }
      for _, lang in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[lang] = {
          {
            name         = "Launch",
            type         = "lldb",
            request      = "launch",
            program      = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd          = "${workspaceFolder}",
            stopOnEntry  = false,
            args         = {},
          },
        }
      end
    end,
  },

  -- ── Go extras (gotest, gorename, gotools UI) ─
  {
    "ray-x/go.nvim",
    ft           = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    build        = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        lsp_inlay_hints = { enable = true },
        dap_debug       = true,
        luasnip         = true,
      })
      -- Extra keymaps for Go
      local map = function(l, r, d)
        vim.keymap.set("n", l, r, { ft = "go", silent = true, desc = d })
      end
      map("<leader>gt",  "<cmd>GoTest<CR>",        "Go Test")
      map("<leader>gT",  "<cmd>GoTestFunc<CR>",    "Go Test Function")
      map("<leader>gf",  "<cmd>GoFmt<CR>",         "Go Format")
      map("<leader>gi",  "<cmd>GoImport<CR>",      "Go Import")
      map("<leader>gI",  "<cmd>GoIfErr<CR>",       "Go Add If Err")
      map("<leader>ga",  "<cmd>GoAlt<CR>",         "Go Alternate (test)")
    end,
  },

  -- ── Git UI (Lazygit) ─────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys         = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },

  -- ── Spectre (project-wide find & replace) ────
  {
    "nvim-pack/nvim-spectre",
    cmd  = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
    },
    opts = {},
  },

  -- ── Test runner ───────────────────────────────
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end,          desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,   desc = "Test summary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({ experimental = { test_table = true } }),
          require("neotest-rust"),
        },
      })
    end,
  },

  -- ── Mason ensure tools (formatters/linters) ──
  {
    "jay-babu/mason-null-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed = {
        "gofumpt", "goimports",
        "clang-format",
        "stylua",
        "black", "flake8",
        "prettier",
        "shfmt",
      },
      automatic_installation = true,
    },
  },
}
