-- ─────────────────────────────────────────────
--  plugins/langs/c.lua  –  C / C++ workload pack
--
--  Owns: clangd, clang-format (none-ls),
--        DAP via lldb, treesitter grammars,
--        all keymaps.
-- ─────────────────────────────────────────────

return {
  -- ── clangd via mason ──────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clangd" })
    end,
  },

  -- ── LSP config for clangd ─────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("clangd", {
        capabilities = caps,
        cmd = {
          "/usr/bin/clangd",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--header-insertion=never",
          "--offset-encoding=utf-16",
        },
      })
      vim.lsp.enable("clangd")
    end,
  },

  -- ── none-ls sources ───────────────────────────
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "c", "cpp" },
    config = function()
      local nls = require("null-ls")
      nls.register({ nls.builtins.formatting.clang_format })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clang-format" })
    end,
  },

  -- ── Treesitter grammars ───────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })
    end,
  },

  -- ── DAP: lldb adapter ─────────────────────────
  {
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp" },
    config = function()
      local dap = require("dap")
      if not dap.adapters.lldb then
        dap.adapters.lldb = {
          type    = "executable",
          command = "/usr/bin/lldb-vscode",
          name    = "lldb",
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name        = "Launch",
            type        = "lldb",
            request     = "launch",
            program     = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd         = "${workspaceFolder}",
            stopOnEntry = false,
            args        = {},
          },
        }
      end
    end,
  },
}
