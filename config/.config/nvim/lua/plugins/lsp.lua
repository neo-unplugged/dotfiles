-- ─────────────────────────────────────────────
--  plugins/lsp.lua  –  LSP infrastructure only
--
--  This file owns:
--    • Mason (installer UI)
--    • mason-lspconfig (bridge)
--    • nvim-lspconfig (shared UI/handlers, LspAttach keymaps)
--    • none-ls + mason-null-ls (formatter/linter plumbing)
--    • fidget (progress spinner)
--
--  It does NOT contain any per-language server config.
--  Each langs/*.lua file declares its own none-ls spec
--  with `optional = true` to register sources safely.
-- ─────────────────────────────────────────────

return {
  -- ── Mason ─────────────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    opts  = {
      ui = {
        border = "rounded",
        icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  -- ── Mason ↔ lspconfig bridge ──────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
      automatic_enable       = { exclude = { "ruff", "rust_analyzer" } },
      ensure_installed       = {}, -- populated by lang packs
    },
  },

  -- ── nvim-lspconfig: shared UI + keymaps ───────
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.schedule(function()
        -- ── Rounded borders ──────────────────────
        vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, cfg)
          cfg = cfg or {}; cfg.border = "rounded"
          return vim.lsp.handlers.hover(_, result, ctx, cfg)
        end
        vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, cfg)
          cfg = cfg or {}; cfg.border = "rounded"
          return vim.lsp.handlers.signature_help(_, result, ctx, cfg)
        end

        -- ── Diagnostics ──────────────────────────
        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN]  = " ",
              [vim.diagnostic.severity.HINT]  = "󰌵 ",
              [vim.diagnostic.severity.INFO]  = " ",
            },
          },
          virtual_text     = { prefix = "●" },
          float            = { border = "rounded", source = true },
          update_in_insert = false,
          severity_sort    = true,
        })

        -- ── Universal LspAttach keymaps ──────────
        vim.api.nvim_create_autocmd("LspAttach", {
          group    = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
          callback = function(ev)
            local buf = ev.buf
            local map = function(m, l, r, desc)
              vim.keymap.set(m, l, r, { buffer = buf, silent = true, desc = desc })
            end
            map("n", "gd",         vim.lsp.buf.definition,                    "Go to definition")
            map("n", "gD",         vim.lsp.buf.declaration,                   "Go to declaration")
            map("n", "gi",         vim.lsp.buf.implementation,                "Go to implementation")
            map("n", "gt",         vim.lsp.buf.type_definition,               "Go to type definition")
            map("n", "gr",         "<cmd>Telescope lsp_references<CR>",       "References")
            map("n", "K",          vim.lsp.buf.hover,                         "Hover docs")
            map("n", "<C-k>",      vim.lsp.buf.signature_help,                "Signature help")
            map("n", "<leader>rn", vim.lsp.buf.rename,                        "Rename symbol")
            map("n", "<F2>",       vim.lsp.buf.rename,                        "Rename symbol")
            map("n", "<leader>ca", vim.lsp.buf.code_action,                   "Code action")
            map("n", "<C-.>",      vim.lsp.buf.code_action,                   "Code action")
            map("n", "<S-A-f>",    function() vim.lsp.buf.format({ async = true }) end, "Format")
            map("n", "[d",         function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
            map("n", "]d",         function() vim.diagnostic.jump({ count = 1 })  end, "Next diagnostic")
          end,
        })
      end)
    end,
  },

  -- ── none-ls (formatters / linters plumbing) ───
  --  Sources are registered by langs/*.lua via their
  --  own `optional = true` none-ls specs. No global
  --  table needed.
  {
    "nvimtools/none-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.shfmt, -- shell (always on)
        },
      })
    end,
  },

  -- ── mason-null-ls (auto-install formatters) ───
  {
    "jay-babu/mason-null-ls.nvim",
    event        = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed       = { "shfmt" }, -- lang packs extend this
      automatic_installation = false,
    },
  },

  -- ── LSP progress spinner ──────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts  = { notification = { window = { winblend = 0 } } },
  },
}
