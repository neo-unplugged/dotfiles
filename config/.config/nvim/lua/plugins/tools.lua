-- ─────────────────────────────────────────────
--  plugins/tools.lua  –  Generic dev tools
--
--  This file owns ONLY language-agnostic tooling:
--    • DAP core + UI (no per-language adapters/configs)
--    • LazyGit
--    • Spectre (find & replace)
--    • Neotest core (no per-language adapters)
--
--  Per-language DAP adapters, neotest adapters, and
--  build/run keymaps all live in langs/*.lua
-- ─────────────────────────────────────────────

return {
  -- ── DAP core + UI ─────────────────────────────
  {
    "mfussenegger/nvim-dap",
    lazy = true, -- lang packs pull this in via dependencies
    keys = {
      { "<F5>",       function() require("dap").continue()          end, desc = "Debug: Continue" },
      { "<F10>",      function() require("dap").step_over()         end, desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into()         end, desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out()          end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end, desc = "Conditional Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open()         end, desc = "Open REPL" },
      { "<leader>du", function() require("dapui").toggle()          end, desc = "Toggle DAP UI" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui",          dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text" },
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"]  = dapui.open
      dap.listeners.before.event_terminated["dapui_config"]  = dapui.close
      dap.listeners.before.event_exited["dapui_config"]      = dapui.close
    end,
  },

  -- ── Git UI ────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys         = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },

  -- ── Project-wide find & replace ───────────────
  {
    "nvim-pack/nvim-spectre",
    cmd  = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
    },
    opts = {},
  },

  -- ── Neotest core ──────────────────────────────
  --  Adapters are added by lang packs via dependencies + config
  {
    "nvim-neotest/neotest",
    lazy = true, -- lang packs load this
    keys = {
      { "<leader>tn", function() require("neotest").run.run()                    end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%"))  end, desc = "Run file tests" },
      { "<leader>ts", function() require("neotest").summary.toggle()             end, desc = "Test summary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
    },
    -- Base setup with no adapters; lang packs extend via their own
    -- neotest dependency + config{ require("neotest").setup({ adapters={...} }) }
    config = function()
      -- intentionally minimal; lang packs call setup() with their adapters
    end,
  },
}
