-- ============================================================
--  plugins/lang_go.lua — Go-specific extras
-- ============================================================

return {
  -- go.nvim: test runner, struct tags, interface stubs, etc.
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg          = false,   -- lsp handled by lspconfig.lua
        lsp_gofumpt      = true,
        lsp_on_attach    = false,
        dap_debug        = true,
        dap_debug_gui    = true,
        run_in_floaterm  = true,
        floaterm = { posititon = "auto", width = 0.45, height = 0.98 },
        diagnostic = { hdlr = true, underline = true, virtual_text = { space = 0, prefix = "■" } },
      })
    end,
    ft    = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    keys = {
      { "<leader>gt", "<cmd>GoTest<CR>",             ft = "go", desc = "Go: Run tests" },
      { "<leader>gT", "<cmd>GoTestFile<CR>",         ft = "go", desc = "Go: Test file" },
      { "<leader>gc", "<cmd>GoCoverage<CR>",         ft = "go", desc = "Go: Coverage" },
      { "<leader>gi", "<cmd>GoImports<CR>",          ft = "go", desc = "Go: Organize imports" },
      { "<leader>gf", "<cmd>GoFmt<CR>",              ft = "go", desc = "Go: Format" },
      { "<leader>gat","<cmd>GoAddTag<CR>",           ft = "go", desc = "Go: Add struct tags" },
      { "<leader>grt","<cmd>GoRmTag<CR>",            ft = "go", desc = "Go: Remove struct tags" },
      { "<leader>gis","<cmd>GoImpl<CR>",             ft = "go", desc = "Go: Implement interface" },
    },
  },
}
