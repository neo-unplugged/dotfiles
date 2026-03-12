-- ============================================================
--  plugins/lsp.lua — LSP + Mason + Autocompletion
--  Uses vim.lsp.config API (nvim 0.11+, lspconfig v2+)
-- ============================================================

return {
  -- ── Mason: LSP installer ────────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    opts  = {
      ui = {
        border = "rounded",
        icons  = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ── Mason-lspconfig bridge ──────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",       -- Lua
        "ts_ls",        -- TypeScript / JavaScript
        "pyright",      -- Python
        "cssls",        -- CSS
        "html",         -- HTML
        "jsonls",       -- JSON
        "eslint",       -- ESLint
        "tailwindcss",  -- Tailwind CSS
        -- Add more here as needed:
        -- "gopls",     -- Go
        -- "clangd",    -- C/C++
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig (new vim.lsp.config API) ─────────────
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── Shared on_attach via autocmd ──────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          -- Inlay hints (VSCode-style)
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, args.buf)
          end
        end,
      })

      -- ── Rounded borders for hover/signature ───────────
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- ── VSCode-style diagnostics ──────────────────────
      vim.diagnostic.config({
        virtual_text     = { prefix = "●", spacing = 4 },
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = { border = "rounded", source = true },
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- ── Server configs (new vim.lsp.config API) ───────
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      vim.lsp.config("ts_ls",       { capabilities = capabilities })
      vim.lsp.config("pyright",     { capabilities = capabilities })
      vim.lsp.config("cssls",       { capabilities = capabilities })
      vim.lsp.config("html",        { capabilities = capabilities })
      vim.lsp.config("jsonls",      { capabilities = capabilities })
      vim.lsp.config("eslint",      { capabilities = capabilities })
      vim.lsp.config("tailwindcss", { capabilities = capabilities })

      -- ── Extra languages (uncomment to enable) ─────────
      -- vim.lsp.config("gopls",         { capabilities = capabilities })
      -- vim.lsp.config("clangd",        { capabilities = capabilities })
      -- vim.lsp.config("rust_analyzer", { capabilities = capabilities })

      -- ── Enable all configured servers ─────────────────
      vim.lsp.enable({
        "lua_ls", "ts_ls", "pyright",
        "cssls", "html", "jsonls",
        "eslint", "tailwindcss",
      })
    end,
  },

  -- ── LSPSaga: VSCode-like UI for LSP ─────────────────────
  {
    "nvimdev/lspsaga.nvim",
    event        = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      ui = {
        border      = "rounded",
        code_action = "💡",
      },
      lightbulb = {
        enable       = true,
        sign         = true,
        virtual_text = true,
      },
      symbol_in_winbar = { enable = true },
    },
    keys = {
      { "<C-.>",     "<cmd>Lspsaga code_action<CR>",     desc = "Code action"     },
      { "K",         "<cmd>Lspsaga hover_doc<CR>",       desc = "Hover docs"      },
      { "gf",        "<cmd>Lspsaga finder<CR>",          desc = "LSP finder"      },
      { "gp",        "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
      { "<F2>",      "<cmd>Lspsaga rename<CR>",          desc = "Rename symbol"   },
      { "<leader>o", "<cmd>Lspsaga outline<CR>",         desc = "Symbol outline"  },
    },
  },

  -- ── nvim-cmp: Autocompletion ─────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Esc>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750  },
          { name = "buffer",   priority = 500  },
          { name = "path",     priority = 250  },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode          = "symbol_text",
            maxwidth      = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip  = "[Snip]",
                buffer   = "[Buf]",
                path     = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },
}
