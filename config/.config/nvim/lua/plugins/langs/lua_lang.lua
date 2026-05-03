-- ─────────────────────────────────────────────
--  plugins/langs/lua_lang.lua  –  Lua workload pack
--  (named lua_lang to avoid clash with builtin `lua`)
--
--  Owns: lua_ls, stylua (none-ls),
--        treesitter grammar.
-- ─────────────────────────────────────────────

return {
  -- ── lua_ls via mason ──────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "lua_ls" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.config("lua_ls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              library         = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },

  -- ── none-ls sources ───────────────────────────
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "lua" },
    config = function()
      local nls = require("null-ls")
      nls.register({ nls.builtins.formatting.stylua })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "stylua" })
    end,
  },

  -- ── Treesitter ────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "lua", "vim", "vimdoc" })
    end,
  },
}
