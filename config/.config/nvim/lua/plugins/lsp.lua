-- ============================================================
--  plugins/lsp.lua — LSP servers: Go, Rust, C/C++, Python
--  Uses vim.lsp.config (nvim 0.11+) instead of lspconfig
-- ============================================================

return {

  -- ── Mason: LSP server installer ──────────────────────────
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

  -- ── Mason-lspconfig bridge ────────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gopls",         -- Go
        "clangd",        -- C / C++
        "pyright",       -- Python (static types)
        "ruff",          -- Python (linting — replaces ruff_lsp)
        "lua_ls",        -- Lua
        -- rust_analyzer intentionally omitted — rustaceanvim handles it
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig (kept for mason bridge compat only) ───
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local navic        = require("nvim-navic")

      -- Enhanced capabilities (snippets, etc.)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Shared on_attach
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
        if client.server_capabilities.documentHighlightProvider then
          local g = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr, group = g,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr, group = g,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- ── vim.lsp.config (0.11+ native API) ───────────────
      -- Each call registers config; vim.lsp.enable() activates it.

      -- Go (gopls)
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          gopls = {
            analyses        = { unusedparams = true, shadow = true },
            staticcheck     = true,
            gofumpt         = true,
            usePlaceholders = true,
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              compositeLiteralTypes  = true,
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      })
      vim.lsp.enable("gopls")

      -- C / C++ (clangd)
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach    = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders    = true,
          completeUnimported = true,
          clangdFileStatus   = true,
        },
      })
      vim.lsp.enable("clangd")

      -- Python (pyright)
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode       = "basic",
              autoImportCompletions  = true,
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
              diagnosticMode         = "workspace",
            },
          },
        },
      })
      vim.lsp.enable("pyright")

      -- Python linting (ruff — replaces ruff_lsp)
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        on_attach    = function(client, bufnr)
          -- Disable hover so pyright handles it
          client.server_capabilities.hoverProvider = false
          on_attach(client, bufnr)
        end,
      })
      vim.lsp.enable("ruff")

      -- Lua (lua_ls)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          Lua = {
            runtime  = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            hint      = { enable = true },
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- ── Diagnostic signs (VSCode style, nvim 0.11+ API) ────
      vim.diagnostic.config({
        virtual_text     = { prefix = "●", source = "if_many" },
        float            = { border = "rounded", source = "always" },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })

      -- Rounded borders on hover / signature help
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
  },

  -- ── Rustaceanvim — best-in-class Rust LSP ────────────────
  {
    "mrcjkb/rustaceanvim",
    version      = "^4",
    ft           = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          local navic = require("nvim-navic")
          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end
          local map = vim.keymap.set
          local o   = { noremap = true, silent = true, buffer = bufnr }
          map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables")    end, vim.tbl_extend("force", o, { desc = "Rust: Runnables" }))
          map("n", "<leader>rt", function() vim.cmd.RustLsp("testables")    end, vim.tbl_extend("force", o, { desc = "Rust: Testables" }))
          map("n", "<leader>re", function() vim.cmd.RustLsp("expandMacro")  end, vim.tbl_extend("force", o, { desc = "Rust: Expand macro" }))
          map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo")    end, vim.tbl_extend("force", o, { desc = "Rust: Open Cargo.toml" }))
        end,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          ["rust-analyzer"] = {
            cargo       = { allFeatures = true },
            checkOnSave = { command = "clippy" },
            inlayHints  = {
              bindingModeHints       = { enable = true },
              chainingHints          = { enable = true },
              closingBraceHints      = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              parameterHints         = { enable = true },
              typeHints              = { enable = true },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = opts
    end,
  },

  -- ── LSP saga ─────────────────────────────────────────────
  {
    "nvimdev/lspsaga.nvim",
    event        = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ui               = { border = "rounded" },
      symbol_in_winbar = { enable = false },
      lightbulb        = { enable = true, sign = true, virtual_text = false },
      code_action      = { show_server_name = true },
    },
    keys = {
      { "K",             "<cmd>Lspsaga hover_doc<CR>",        desc = "Hover doc" },
      { "<F2>",          "<cmd>Lspsaga rename<CR>",            desc = "Rename symbol" },
      { "<C-.>",         "<cmd>Lspsaga code_action<CR>",       desc = "Code actions", mode = { "n", "v" } },
      { "<leader>o",     "<cmd>Lspsaga outline<CR>",           desc = "Symbol outline" },
      { "<leader>ci",    "<cmd>Lspsaga incoming_calls<CR>",    desc = "Incoming calls" },
      { "<leader>co",    "<cmd>Lspsaga outgoing_calls<CR>",    desc = "Outgoing calls" },
    },
  },

  -- ── Mason tool installer ──────────────────────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gofumpt", "goimports", "golines",
        "rustfmt",
        "clang-format",
        "black", "isort",
        "golangci-lint",
        "cppcheck",
        "delve",
        "codelldb",
        "debugpy",
      },
    },
  },
}
