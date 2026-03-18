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
        -- Lua
        "lua_ls",
        -- Web
        "ts_ls", "cssls", "html", "jsonls", "eslint", "tailwindcss",
        -- Python
        "pyright",
        -- Go
        "gopls",
        -- Rust: managed by rustup, not Mason
        -- C/C++: clangd comes with the system `clang` package — do NOT
        --        add it here. Mason will re-download and fail on distros
        --        (Arch, Nix) that already provide it via PATH.
        -- CMake
        "neocmake",
      },
      -- Keep false: true = Mason checks + reinstalls on every Neovim
      -- startup, causing the constant install/fail popups you're seeing.
      automatic_installation = false,
    },
  },

  -- ── mason-tool-installer: formatters & linters ───────────
  --  Ensures the non-LSP tools used by conform/nvim-lint are present.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Lua
        "stylua",
        -- Web
        "prettier", "eslint_d",
        -- Python
        "black", "isort", "flake8",
        -- Go  (gofmt ships with Go toolchain; extra tools via Mason)
        "goimports", "golangci-lint",
        -- C/C++
        "clang-format",
      },
      auto_update    = false,
      run_on_start   = true,
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

          local map   = vim.keymap.set
          local bopts = { buffer = args.buf, noremap = true, silent = true }

          -- Navigation
          map("n", "gd",    vim.lsp.buf.definition,     vim.tbl_extend("force", bopts, { desc = "Go to definition" }))
          map("n", "gD",    vim.lsp.buf.declaration,    vim.tbl_extend("force", bopts, { desc = "Go to declaration" }))
          map("n", "gr",    vim.lsp.buf.references,     vim.tbl_extend("force", bopts, { desc = "Find references" }))
          map("n", "gi",    vim.lsp.buf.implementation, vim.tbl_extend("force", bopts, { desc = "Go to implementation" }))
          map("n", "gy",    vim.lsp.buf.type_definition,vim.tbl_extend("force", bopts, { desc = "Go to type definition" }))
          map("n", "<F12>", vim.lsp.buf.definition,     vim.tbl_extend("force", bopts, { desc = "Go to definition" }))

          -- Actions
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
                                                      vim.tbl_extend("force", bopts, { desc = "Format document" }))
          map("n", "<leader>lr", vim.lsp.buf.rename,  vim.tbl_extend("force", bopts, { desc = "Rename symbol" }))
          map("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", bopts, { desc = "Code action" }))

          -- Diagnostics
          map("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", bopts, { desc = "Show diagnostics" }))
          map("n", "]d",         vim.diagnostic.goto_next,  vim.tbl_extend("force", bopts, { desc = "Next diagnostic" }))
          map("n", "[d",         vim.diagnostic.goto_prev,  vim.tbl_extend("force", bopts, { desc = "Prev diagnostic" }))

          -- Inlay hints toggle (VSCode-style, nvim 0.10+)
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            -- Toggle with <leader>lh
            map("n", "<leader>lh", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
            end, vim.tbl_extend("force", bopts, { desc = "Toggle inlay hints" }))
          end

          -- Go-specific: organize imports on save
          if client.name == "gopls" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.code_action({
                  context = { only = { "source.organizeImports" } },
                  apply   = true,
                })
              end,
            })
          end

          -- clangd: switch between header ↔ source (Alt+O)
          if client.name == "clangd" then
            map("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<CR>",
              vim.tbl_extend("force", bopts, { desc = "Switch header/source" }))
          end
        end,
      })

      -- ── Rounded borders for hover / signature help ────
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover,          { border = "rounded" })
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

  -- ── clangd_extensions: extra C/C++ powers ───────────────
  --  Provides: memory-layout view, enhanced inlay hints, AST viewer,
  --  type hierarchy, symbol info — all things clangd exposes beyond spec.
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    opts = {
      inlay_hints = {
        inline            = true,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "← ",
        other_hints_prefix     = "⇒ ",
        max_len_align          = false,
        right_align            = false,
        right_align_padding    = 7,
        highlight              = "Comment",
        priority               = 100,
      },
      ast = {
        role_icons = {
          type            = "",
          declaration     = "",
          expression      = "",
          specifier       = "",
          statement       = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound      = "",
          Recovery      = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
    keys = {
      { "<leader>ca", "<cmd>ClangdAST<CR>",           ft = { "c", "cpp" }, desc = "C/C++ AST view" },
      { "<leader>cm", "<cmd>ClangdMemoryUsage<CR>",   ft = { "c", "cpp" }, desc = "Clangd memory usage" },
      { "<leader>ct", "<cmd>ClangdTypeHierarchy<CR>", ft = { "c", "cpp" }, desc = "Type hierarchy" },
      { "<leader>cs", "<cmd>ClangdSymbolInfo<CR>",    ft = { "c", "cpp" }, desc = "Symbol info" },
    },
  },

  -- ── rustaceanvim: full Rust powers ──────────────────────
  --  Replaces a plain rust_analyzer lspconfig entry.
  --  Handles rustup toolchain detection automatically.
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft      = { "rust" },
    -- No opts{} — config lives in servers.lua via vim.g.rustaceanvim
    init = function()
      -- rustaceanvim reads vim.g.rustaceanvim at startup
      vim.g.rustaceanvim = {
        tools = {
          hover_actions         = { auto_focus = true },
          float_win_config      = { border = "rounded" },
        },
        server = {
          -- settings are forwarded from servers.lua's vim.lsp.config("rust_analyzer")
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            local b   = { buffer = bufnr, noremap = true, silent = true }
            map("n", "<leader>rr", "<cmd>RustLsp runnables<CR>",      vim.tbl_extend("force", b, { desc = "Rust runnables" }))
            map("n", "<leader>rd", "<cmd>RustLsp debuggables<CR>",    vim.tbl_extend("force", b, { desc = "Rust debuggables" }))
            map("n", "<leader>rt", "<cmd>RustLsp testables<CR>",      vim.tbl_extend("force", b, { desc = "Rust testables" }))
            map("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>",    vim.tbl_extend("force", b, { desc = "Expand macro" }))
            map("n", "<leader>rc", "<cmd>RustLsp openCargo<CR>",      vim.tbl_extend("force", b, { desc = "Open Cargo.toml" }))
            map("n", "<leader>rp", "<cmd>RustLsp parentModule<CR>",   vim.tbl_extend("force", b, { desc = "Parent module" }))
            map("n", "<leader>rm", "<cmd>RustLsp moveItem down<CR>",  vim.tbl_extend("force", b, { desc = "Move item down" }))
            map("n", "<leader>rM", "<cmd>RustLsp moveItem up<CR>",    vim.tbl_extend("force", b, { desc = "Move item up" }))
            map("n", "K",          "<cmd>RustLsp hover actions<CR>",  vim.tbl_extend("force", b, { desc = "Rust hover actions" }))
          end,
        },
      }
    end,
  },
}
