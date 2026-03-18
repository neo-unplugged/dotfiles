-- ============================================================
--  plugins/lsp/init.lua — LSP core: Mason + lspconfig + UI
--
--  Split:
--    init.lua       ← you are here (plugin specs, on_attach, diagnostics)
--    servers.lua    ← vim.lsp.config() per-server settings
--    completion.lua ← nvim-cmp + luasnip + lspkind
-- ============================================================

return {
  -- ── Mason: LSP/tool installer ────────────────────────────
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

  -- ── Mason-lspconfig: auto-install servers ────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",      -- Lua
        "ts_ls",       -- TypeScript / JavaScript
        "pyright",     -- Python
        "cssls",       -- CSS
        "html",        -- HTML
        "jsonls",      -- JSON
        "eslint",      -- ESLint
        "tailwindcss", -- Tailwind CSS
        -- "gopls",    -- Go
        -- "clangd",   -- C/C++
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig ──────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- ── Capabilities (advertise nvim-cmp to LSP) ──────
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── on_attach: runs when LSP connects to a buffer ─
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local map = vim.keymap.set
          local bopts = { buffer = args.buf, noremap = true, silent = true }

          -- Navigation
          map("n", "gd",  vim.lsp.buf.definition,    vim.tbl_extend("force", bopts, { desc = "Go to definition" }))
          map("n", "gD",  vim.lsp.buf.declaration,   vim.tbl_extend("force", bopts, { desc = "Go to declaration" }))
          map("n", "gr",  vim.lsp.buf.references,    vim.tbl_extend("force", bopts, { desc = "Find references" }))
          map("n", "gi",  vim.lsp.buf.implementation, vim.tbl_extend("force", bopts, { desc = "Go to implementation" }))
          map("n", "<F12>", vim.lsp.buf.definition,  vim.tbl_extend("force", bopts, { desc = "Go to definition" }))

          -- Actions
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
                                                     vim.tbl_extend("force", bopts, { desc = "Format document" }))
          -- Diagnostics
          map("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", bopts, { desc = "Show diagnostics" }))
          map("n", "]d",         vim.diagnostic.goto_next,  vim.tbl_extend("force", bopts, { desc = "Next diagnostic" }))
          map("n", "[d",         vim.diagnostic.goto_prev,  vim.tbl_extend("force", bopts, { desc = "Prev diagnostic" }))

          -- Inlay hints (VSCode-style, nvim 0.10+)
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- ── Rounded borders for hover / signature help ────
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- ── VSCode-style diagnostics ──────────────────────
      vim.diagnostic.config({
        virtual_text     = { prefix = "●", spacing = 4 },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌶",
            [vim.diagnostic.severity.INFO]  = "󰋽",
          },
        },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = { border = "rounded", source = true },
      })

      -- ── Load server configs and enable them ───────────
      require("plugins.lsp.servers").setup(capabilities)
    end,
  },

  -- ── LSPSaga: VSCode-like LSP UI ─────────────────────────
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
      { "<C-.>",     "<cmd>Lspsaga code_action<CR>",     desc = "Code action" },
      { "K",         "<cmd>Lspsaga hover_doc<CR>",       desc = "Hover docs" },
      { "gf",        "<cmd>Lspsaga finder<CR>",          desc = "LSP finder" },
      { "gp",        "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
      { "<F2>",      "<cmd>Lspsaga rename<CR>",          desc = "Rename symbol" },
      { "<leader>o", "<cmd>Lspsaga outline<CR>",         desc = "Symbol outline" },
    },
  },
}
