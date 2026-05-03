-- ─────────────────────────────────────────────
--  plugins/langs/go.lua  –  Go workload pack
--
--  Owns: gopls, gofumpt/goimports (none-ls),
--        dap-go, go.nvim extras, neotest-go,
--        treesitter grammars, all keymaps.
-- ─────────────────────────────────────────────

return {
  -- ── gopls via mason-lspconfig ─────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gopls" })
    end,
  },

  -- ── LSP config for gopls ──────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("gopls", {
        capabilities = caps,
        settings = {
          gopls = {
            gofumpt         = true,
            staticcheck     = true,
            usePlaceholders = true,
            analyses        = { unusedparams = true, shadow = true },
            codelenses      = { generate = true, gc_details = true, test = true, tidy = true },
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      })
      vim.lsp.enable("gopls")
    end,
  },

  -- ── none-ls sources (registered safely after none-ls loads) ──
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "go" },
    config = function()
      local nls = require("null-ls")
      nls.register({
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.goimports,
      })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gofumpt", "goimports" })
    end,
  },

  -- ── Treesitter grammars ───────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
    end,
  },

  -- ── DAP: delve adapter ────────────────────────
  {
    "leoluz/nvim-dap-go",
    ft           = { "go" },
    dependencies = { "mfussenegger/nvim-dap" },
    config       = function() require("dap-go").setup() end,
  },

  -- ── Neotest adapter ───────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-go" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-go")({ experimental = { test_table = true } }))
    end,
  },

  -- ── go.nvim extras ────────────────────────────
  {
    "ray-x/go.nvim",
    ft           = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    build        = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        lsp_inlay_hints = { enable = true },
        dap_debug       = true,
        luasnip         = true,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern  = { "go", "gomod" },
        group    = vim.api.nvim_create_augroup("GoKeymaps", { clear = true }),
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>gt",  "<cmd>GoTest<CR>",      "Go: Test")
          map("<leader>gT",  "<cmd>GoTestFunc<CR>",  "Go: Test function")
          map("<leader>gf",  "<cmd>GoFmt<CR>",       "Go: Format")
          map("<leader>gi",  "<cmd>GoImport<CR>",    "Go: Import")
          map("<leader>gI",  "<cmd>GoIfErr<CR>",     "Go: Add if err")
          map("<leader>ga",  "<cmd>GoAlt<CR>",       "Go: Alternate (test file)")
        end,
      })
    end,
  },
}
