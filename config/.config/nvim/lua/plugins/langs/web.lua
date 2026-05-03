-- ─────────────────────────────────────────────
--  plugins/langs/web.lua  –  Web workload pack
--  JS · TS · HTML · CSS · JSON · YAML · TOML
--
--  Owns: ts_ls, html, cssls, jsonls, taplo,
--        prettier (none-ls), autotag,
--        treesitter grammars, markdown preview.
-- ─────────────────────────────────────────────

return {
  -- ── LSP servers via mason ─────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "ts_ls", "html", "cssls", "jsonls", "taplo", "bashls",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      for _, srv in ipairs({ "ts_ls", "html", "cssls", "jsonls", "taplo", "bashls" }) do
        vim.lsp.config(srv, { capabilities = caps })
      end
      vim.lsp.enable({ "ts_ls", "html", "cssls", "jsonls", "taplo", "bashls" })
    end,
  },

  -- ── none-ls sources ───────────────────────────
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "javascript", "typescript", "typescriptreact", "javascriptreact", "html", "css", "json", "yaml", "toml", "markdown" },
    config = function()
      local nls = require("null-ls")
      nls.register({
        nls.builtins.formatting.prettier.with({
          extra_filetypes = { "toml" },
        }),
      })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "prettier" })
    end,
  },

  -- ── Treesitter grammars ───────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml",
        "bash", "markdown", "markdown_inline",
      })
    end,
  },

  -- ── Markdown preview ──────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreview", "MarkdownPreviewToggle" },
    ft    = { "markdown" },
    build = "cd app && npm install",
  },
}
