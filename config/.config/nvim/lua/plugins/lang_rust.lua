-- ============================================================
--  plugins/lang_rust.lua — Rust extras (crates.nvim)
-- ============================================================

return {
  -- Cargo.toml: version hints, crate search, update
  {
    "saecki/crates.nvim",
    ft      = { "toml", "rust" },
    tag     = "stable",
    event   = "BufRead Cargo.toml",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      src = {
        cmp = { enabled = true },   -- adds crates as a cmp source in Cargo.toml
      },
      popup = { border = "rounded" },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      -- Extra keymaps inside Cargo.toml
      local map = vim.keymap.set
      local o = { noremap = true, silent = true, buffer = true }

      vim.api.nvim_create_autocmd("BufRead", {
        pattern  = "Cargo.toml",
        callback = function()
          map("n", "<leader>cv",  crates.show_versions_popup,       vim.tbl_extend("force", o, { desc = "Crate versions" }))
          map("n", "<leader>cf",  crates.show_features_popup,       vim.tbl_extend("force", o, { desc = "Crate features" }))
          map("n", "<leader>cd",  crates.show_dependencies_popup,   vim.tbl_extend("force", o, { desc = "Crate deps" }))
          map("n", "<leader>cu",  crates.upgrade_crate,             vim.tbl_extend("force", o, { desc = "Upgrade crate" }))
          map("n", "<leader>cU",  crates.upgrade_all_crates,        vim.tbl_extend("force", o, { desc = "Upgrade all crates" }))
          map("n", "<leader>cx",  crates.expand_plain_crate_to_inline_table, vim.tbl_extend("force", o, { desc = "Expand crate" }))
        end,
      })
    end,
  },
}
