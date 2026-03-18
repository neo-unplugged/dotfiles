-- ============================================================
--  plugins/lsp/servers.lua — Per-server LSP configuration
--
--  To add a new server:
--    1. Add it to mason-lspconfig's ensure_installed (lsp/init.lua)
--    2. Add vim.lsp.config() + entry in vim.lsp.enable() below
--    3. Uncomment the matching line in the extras section
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
      },
    },
  })

  -- ── Web ──────────────────────────────────────────────────
  vim.lsp.config("ts_ls", { capabilities = capabilities })
  vim.lsp.config("cssls", { capabilities = capabilities })
  vim.lsp.config("html", { capabilities = capabilities })
  vim.lsp.config("jsonls", { capabilities = capabilities })
  vim.lsp.config("eslint", { capabilities = capabilities })
  vim.lsp.config("tailwindcss", { capabilities = capabilities })

  -- ── Python ───────────────────────────────────────────────
  vim.lsp.config("pyright", { capabilities = capabilities })

  -- ── Extras (uncomment + add to ensure_installed to enable)
  -- vim.lsp.config("gopls",         { capabilities = capabilities })
  vim.lsp.config("clangd", { capabilities = capabilities })
  vim.lsp.config("rust_analyzer", { capabilities = capabilities })

  -- ── Enable all active servers ────────────────────────────
  vim.lsp.enable({
    "lua_ls",
    "ts_ls", "cssls", "html", "jsonls", "eslint", "tailwindcss",
    "pyright",
    -- "gopls",
    -- "clangd",
    -- "rust_analyzer",
  })
end

return M
