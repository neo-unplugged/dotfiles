-- ─────────────────────────────────────────────
--  plugins/langs/rust.lua  –  Rust workload pack
--
--  Owns: rustaceanvim (manages rust-analyzer),
--        clippy, neotest-rust, DAP via lldb,
--        treesitter grammar, all keymaps.
-- ─────────────────────────────────────────────

return {
  -- ── rustaceanvim (replaces rust-analyzer in mason) ──
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft      = { "rust" },
    config  = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.g.rustaceanvim = {
        server = {
          capabilities    = caps,
          default_settings = {
            ["rust-analyzer"] = {
              cargo       = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlayHints  = {
                bindingModeHints = { enable = true },
                chainingHints    = { enable = true },
                parameterHints   = { enable = true },
                typeHints        = { enable = true },
              },
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "rust",
        group    = vim.api.nvim_create_augroup("RustKeymaps", { clear = true }),
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>re", "<cmd>RustLsp expandMacro<CR>",  "Rust: Expand macro")
          map("<leader>rr", "<cmd>RustLsp runnables<CR>",    "Rust: Runnables")
          map("<leader>rt", "<cmd>RustLsp testables<CR>",    "Rust: Testables")
          map("<leader>rd", "<cmd>RustLsp debuggables<CR>",  "Rust: Debuggables")
        end,
      })
    end,
  },

  -- ── Treesitter grammar ────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust" })
    end,
  },

  -- ── DAP: lldb adapter for Rust ────────────────
  {
    "mfussenegger/nvim-dap",
    ft = { "rust" },
    config = function()
      local dap = require("dap")
      dap.adapters.lldb = {
        type    = "executable",
        command = "/usr/bin/lldb-vscode", -- adjust to your lldb path
        name    = "lldb",
      }
      dap.configurations.rust = {
        {
          name       = "Launch",
          type       = "lldb",
          request    = "launch",
          program    = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd        = "${workspaceFolder}",
          stopOnEntry = false,
          args       = {},
        },
      }
    end,
  },

  -- ── Neotest adapter ───────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = { "rouge8/neotest-rust" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-rust"))
    end,
  },
}
