-- ─────────────────────────────────────────────
--  plugins/langs/python.lua  –  Python workload pack
--
--  Owns: pyright, black + flake8 (none-ls),
--        treesitter grammar, keymaps.
-- ─────────────────────────────────────────────

return {
  -- ── pyright via mason ─────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "pyright" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.config("pyright", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("pyright")
    end,
  },

  -- ── none-ls sources ───────────────────────────
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "python" },
    config = function()
      local nls = require("null-ls")
      nls.register({
        nls.builtins.formatting.black,
        nls.builtins.diagnostics.flake8,
      })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "black", "flake8" })
    end,
  },

  -- ── Treesitter ────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python" })
    end,
  },
}
