-- ============================================================
--  plugins/formatting.lua — conform.nvim (format on save)
-- ============================================================

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format document",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Go: gofumpt + goimports
        go  = { "goimports", "gofumpt" },
        -- Rust: rustfmt (via rustaceanvim's cargo fmt)
        rust = { "rustfmt" },
        -- C / C++
        c   = { "clang_format" },
        cpp = { "clang_format" },
        -- Python: isort then black
        python = { "isort", "black" },
        -- Lua
        lua = { "stylua" },
        -- Fallback for everything else
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms   = 1000,
        lsp_fallback = true,
      },
      formatters = {
        -- Customize clang-format style
        clang_format = {
          prepend_args = { "--style=LLVM" },
        },
      },
    },
  },
}
