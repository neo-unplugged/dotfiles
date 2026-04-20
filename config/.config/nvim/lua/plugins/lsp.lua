-- ─────────────────────────────────────────────
--  plugins/lsp.lua  –  Neovim 0.11+ native LSP
-- ─────────────────────────────────────────────

return {
  -- ── Mason (LSP installer UI) ──────────────────
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
      -- Servers that should NOT be auto-started even if installed
      automatic_enable = {
        exclude = { "ruff", "rust_analyzer" },
      },
      ensure_installed = {
        "gopls",
        -- clangd excluded: using system clangd v22 to avoid Mason conflict
        "rust_analyzer",
        "lua_ls",
        "pyright",
        "ts_ls",          -- replaces deprecated tsserver
        "html",
        "cssls",
        "jsonls",
        "bashls",
        "taplo",
      },
      automatic_installation = true,
    },
  },

  -- ── Native LSP setup (Neovim 0.11+) ──────────
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- Rounded borders for hover & signature
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- Diagnostics (0.11 API — no sign_define)
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

      -- Common on_attach keymaps via LspAttach autocmd (0.11 style)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local map = function(m, l, r, desc)
            vim.keymap.set(m, l, r, { buffer = buf, silent = true, desc = desc })
          end
          map("n", "gd",         vim.lsp.buf.definition,              "Go to definition")
          map("n", "gD",         vim.lsp.buf.declaration,             "Go to declaration")
          map("n", "gi",         vim.lsp.buf.implementation,          "Go to implementation")
          map("n", "gt",         vim.lsp.buf.type_definition,         "Go to type definition")
          map("n", "gr",         "<cmd>Telescope lsp_references<CR>", "References")
          map("n", "K",          vim.lsp.buf.hover,                   "Hover docs")
          map("n", "<C-k>",      vim.lsp.buf.signature_help,          "Signature help")
          map("n", "<leader>rn", vim.lsp.buf.rename,                  "Rename symbol")
          map("n", "<F2>",       vim.lsp.buf.rename,                  "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action,             "Code action")
          map("n", "<C-.>",      vim.lsp.buf.code_action,             "Code action")
          map("n", "<S-A-f>",    function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")
        end,
      })

      -- ── Server configs via vim.lsp.config (0.11 native) ──

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

      vim.lsp.config("clangd", {
        capabilities = caps,
        cmd = {
          "/usr/bin/clangd",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--header-insertion=never",  -- safer default without compile_commands.json
          "--offset-encoding=utf-16",  -- avoids encoding warning with nvim
        },
      })

      vim.lsp.config("lua_ls", {
        capabilities = caps,
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              library         = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry   = { enable = false },
          },
        },
      })

      vim.lsp.config("pyright",  { capabilities = caps })
      vim.lsp.config("ts_ls",    { capabilities = caps })
      for _, srv in ipairs({ "html", "cssls", "jsonls", "bashls", "taplo" }) do
        vim.lsp.config(srv, { capabilities = caps })
      end

      -- Enable only the servers we want
      -- ruff excluded (not installed); rust_analyzer excluded (rustaceanvim handles it)
      vim.lsp.enable({
        "gopls", "clangd", "lua_ls", "pyright",
        "ts_ls", "html", "cssls", "jsonls", "bashls", "taplo",
      })
    end,
  },

  -- ── Rust (rustaceanvim manages rust-analyzer) ─
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft      = { "rust" },
    config  = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.g.rustaceanvim = {
        server = {
          capabilities = caps,
          default_settings = {
            ["rust-analyzer"] = {
              cargo       = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlayHints  = {
                bindingModeHints = { enable = true },
                chainingHints    = { enable = true },
                parameterHints   = { enable = true },
                typeHints        = { enable = true },
              },
            },
          },
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "rust",
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>re", "<cmd>RustLsp expandMacro<CR>", "Expand macro")
          map("<leader>rr", "<cmd>RustLsp runnables<CR>",   "Runnables")
          map("<leader>rt", "<cmd>RustLsp testables<CR>",   "Testables")
          map("<leader>rd", "<cmd>RustLsp debuggables<CR>", "Debuggables")
        end,
      })
    end,
  },

  -- ── none-ls (formatters / linters) ───────────
  {
    "nvimtools/none-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.clang_format,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          -- flake8/ruff diagnostics: use ruff as LSP instead (see mason ensure_installed)
          -- nls.builtins.diagnostics.flake8,  -- removed: needs manual setup
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.prettier.with({ extra_filetypes = { "toml" } }),
        },
      })
    end,
  },

  -- ── Mason tool installer (formatters/linters) ─
  -- VeryLazy to avoid racing with mason-lspconfig on startup
  {
    "jay-babu/mason-null-ls.nvim",
    event        = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "gofumpt", "goimports",
          "clang-format",
          "stylua",
          "black",
          "prettier",
          "shfmt",
        },
        automatic_installation = false,
      })
    end,
  },

  -- ── LSP progress spinner ──────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts  = { notification = { window = { winblend = 0 } } },
  },
}
