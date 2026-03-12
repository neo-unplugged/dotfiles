-- ============================================================
--  plugins/formatting.lua — Formatting & Linting
-- ============================================================

return {
  -- ── Conform: formatter (like VSCode Format Document) ─────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    opts  = {
      formatters_by_ft = {
        lua             = { "stylua" },
        javascript      = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        css             = { "prettier" },
        html            = { "prettier" },
        json            = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        python          = { "isort", "black" },
        go              = { "gofmt" },
        c               = { "clang-format" },
        cpp             = { "clang-format" },
        rust            = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- fallback to LSP if no formatter found
      },
    },
    keys  = {
      {
        "<A-S-f>", -- Alt+Shift+F like VSCode
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format document",
      },
    },
  },

  -- ── nvim-lint: linting ────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript      = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        python          = { "flake8" },
      }

      -- Lint on save and buffer enter
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
