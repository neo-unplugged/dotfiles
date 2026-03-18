-- ============================================================
--  plugins/lsp/servers.lua — Per-server LSP configuration
--
--  To add a new server:
--    1. Add it to mason-lspconfig's ensure_installed (lsp/init.lua)
--    2. Add vim.lsp.config() + entry in vim.lsp.enable() below
-- ============================================================

local M = {}

function M.setup(capabilities)
  -- ── Lua ──────────────────────────────────────────────────
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace   = { checkThirdParty = false },
        telemetry   = { enable = false },
        hint        = { enable = true },   -- inlay hints
      },
    },
  })

  -- ── Web ──────────────────────────────────────────────────
  vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints            = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints    = true,
          includeInlayVariableTypeHints             = true,
          includeInlayPropertyDeclarationTypeHints  = true,
          includeInlayFunctionLikeReturnTypeHints   = true,
          includeInlayEnumMemberValueHints          = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints            = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints    = true,
          includeInlayVariableTypeHints             = true,
          includeInlayPropertyDeclarationTypeHints  = true,
          includeInlayFunctionLikeReturnTypeHints   = true,
          includeInlayEnumMemberValueHints          = true,
        },
      },
    },
  })
  vim.lsp.config("cssls",       { capabilities = capabilities })
  vim.lsp.config("html",        { capabilities = capabilities })
  vim.lsp.config("jsonls",      { capabilities = capabilities })
  vim.lsp.config("eslint",      { capabilities = capabilities })
  vim.lsp.config("tailwindcss", { capabilities = capabilities })

  -- ── Python ───────────────────────────────────────────────
  vim.lsp.config("pyright", {
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode       = "standard",
          autoSearchPaths        = true,
          useLibraryCodeForTypes = true,
          inlayHints = {
            variableTypes         = true,
            functionReturnTypes   = true,
            callArgumentNames     = true,
            pytestParameters      = true,
          },
        },
      },
    },
  })

  -- ── Go ───────────────────────────────────────────────────
  vim.lsp.config("gopls", {
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams  = true,
          unusedvariable = true,
          shadow        = true,
          fieldalignment = true,
          nilness       = true,
          useany        = true,
        },
        staticcheck    = true,
        gofumpt        = true,       -- stricter gofmt
        codelenses = {
          gc_details      = true,    -- show GC pressure inline
          generate        = true,
          regenerate_cgo  = true,
          run_govulncheck = true,
          test            = true,
          tidy            = true,
          upgrade_dependency = true,
          vendor          = true,
        },
        hints = {
          assignVariableTypes    = true,
          compositeLiteralFields = true,
          compositeLiteralTypes  = true,
          constantValues         = true,
          functionTypeParameters = true,
          parameterNames         = true,
          rangeVariableTypes     = true,
        },
        -- Deep completion: resolve object members across packages
        completeUnimported     = true,
        usePlaceholders        = true,   -- snippet placeholders in completions
        deepCompletion         = true,
        matcher                = "fuzzy",
        symbolMatcher          = "fuzzy",
        semanticTokens         = true,
      },
    },
  })

  -- ── Rust ─────────────────────────────────────────────────
  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures    = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        checkOnSave = {
          command        = "clippy",   -- clippy instead of check
          allFeatures    = true,
          extraArgs      = { "--no-deps" },
        },
        procMacro = {
          enable         = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        inlayHints = {
          bindingModeHints         = { enable = true },
          chainingHints            = { enable = true },   -- a.b().c() ← types between
          closingBraceHints        = { enable = true, minLines = 10 },
          closureCaptureHints      = { enable = true },
          closureReturnTypeHints   = { enable = "always" },
          closureStyle             = "impl_fn",
          discriminantHints        = { enable = "always" },
          expressionAdjustmentHints = { enable = "always" },
          implicitDrops            = { enable = true },
          lifetimeElisionHints     = { enable = "skip_trivial", useParameterNames = true },
          maxLength                = { enable = true, value = 25 },
          parameterHints           = { enable = true },
          rangeExclusiveHints      = { enable = true },
          reborrowHints            = { enable = "mutable" },
          renderColons             = { enable = true },
          typeHints                = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
        },
        completion = {
          autoimport        = { enable = true },
          autoself          = { enable = true },
          callable          = { snippets = "fill_arguments" },  -- fills fn args
          fullFunctionSignatures = { enable = true },
          postfix           = { enable = true },
          privateEditable   = { enable = true },
        },
        hover = {
          actions = {
            enable          = true,
            references      = { enable = true },
            run             = { enable = true },
            debug           = { enable = true },
            gotoTypeDef     = { enable = true },
            implementations = { enable = true },
          },
          documentation    = { enable = true, keywords = { enable = true } },
          memoryLayout     = { enable = true, alignment = "both", niches = true, offset = "both", size = "both" },
        },
        lens = {
          enable          = true,
          references      = { adt = { enable = true }, enumVariant = { enable = true }, method = { enable = true }, trait = { enable = true } },
          implementations = { enable = true },
          run             = { enable = true },
          debug           = { enable = true },
          interpret       = { tests = { enable = true } },
        },
        diagnostics = {
          enable          = true,
          experimental    = { enable = true },
          warningsAsHint  = {},
        },
        semanticHighlighting = { strings = { enable = "true" } },
      },
    },
  })

  -- ── C / C++ ──────────────────────────────────────────────
  vim.lsp.config("clangd", {
    capabilities = (function()
      -- clangd ships its own offsetEncoding; prevent conflict with cmp
      local cap = vim.deepcopy(capabilities)
      cap.offsetEncoding = { "utf-16" }
      return cap
    end)(),
    cmd = {
      "clangd",
      "--background-index",          -- persist index across restarts
      "--clang-tidy",                -- lint while typing
      "--header-insertion=iwyu",     -- include-what-you-use style
      "--completion-style=detailed", -- show full signature in popup
      "--function-arg-placeholders", -- snippet placeholders for args
      "--fallback-style=llvm",
      "--enable-config",             -- respect .clangd project files
      "--offset-encoding=utf-16",
      "-j=4",                        -- background index threads
    },
    init_options = {
      usePlaceholders    = true,     -- snippet fill-in for function args
      completeUnimported = true,     -- complete across TUs
      clangdFileStatus   = true,     -- show indexing status
    },
  })

  -- ── CMake ────────────────────────────────────────────────
  vim.lsp.config("cmake", {
    capabilities = capabilities,
    init_options = {
      buildDirectory = "build",
    },
  })

  -- ── Enable all active servers ────────────────────────────
  vim.lsp.enable({
    "lua_ls",
    "ts_ls", "cssls", "html", "jsonls", "eslint", "tailwindcss",
    "pyright",
    "gopls",
    "rust_analyzer",
    "clangd",
    "cmake",
  })
end

return M
