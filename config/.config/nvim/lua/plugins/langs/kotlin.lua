-- ─────────────────────────────────────────────
--  plugins/langs/kotlin.lua  –  Kotlin workload pack
--
--  Pure Kotlin: LSP, ktlint, DAP, neotest,
--  treesitter, standalone run/script keymaps.
--  No Android / Gradle / ADB dependencies.
--
--  Works on desktop AND Termux without changes.
-- ─────────────────────────────────────────────

return {
  -- ── kotlin_language_server via mason ──────────
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "kotlin_language_server" })
    end,
  },

  -- ── LSP config ────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.config("kotlin_language_server", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        root_dir     = require("lspconfig.util").root_pattern(
          "settings.gradle.kts", "settings.gradle", "gradlew", "pom.xml"
        ),
        settings = {
          kotlin = {
            compiler   = { jvm = { target = "17" } },
            completion = { snippets = { enabled = true } },
            inlayHints = { typeHints = true, parameterHints = true },
          },
        },
      })
      vim.lsp.enable("kotlin_language_server")
    end,
  },

  -- ── none-ls sources ───────────────────────────
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "kotlin" },
    config = function()
      local nls = require("null-ls")
      nls.register({
        nls.builtins.formatting.ktlint,
        nls.builtins.diagnostics.ktlint,
      })
    end,
  },

  -- ── none-ls tool installer ────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ktlint", "kotlin-debug-adapter" })
    end,
  },

  -- ── DAP: kotlin-debug-adapter ─────────────────
  {
    "mfussenegger/nvim-dap",
    ft = { "kotlin" },
    config = function()
      local dap = require("dap")
      dap.adapters.kotlin = {
        type    = "executable",
        command = "kotlin-debug-adapter",
        options = { auto_continue_if_many_stopped = false },
      }
      dap.configurations.kotlin = {
        {
          type        = "kotlin",
          request     = "launch",
          name        = "Kotlin Launch",
          projectRoot = "${workspaceFolder}",
          mainClass   = function()
            return vim.fn.input("Main class: ", "MainKt")
          end,
        },
      }
    end,
  },

  -- ── Neotest adapter ───────────────────────────
  {
    "nvim-neotest/neotest",
    dependencies = { "codymikol/neotest-kotlin" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-kotlin"))
    end,
  },

  -- ── Syntax / filetype detection ───────────────
  { "udalov/kotlin-vim", ft = { "kotlin" } },

  -- ── Standalone Kotlin keymaps ─────────────────
  {
    "udalov/kotlin-vim",
    ft = { "kotlin" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "kotlin",
        group    = vim.api.nvim_create_augroup("KotlinKeymaps", { clear = true }),
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>kr", function()
            local file = vim.fn.expand("%")
            local jar  = vim.fn.expand("%:r") .. ".jar"
            vim.cmd(string.format(
              "!kotlinc %s -include-runtime -d %s && java -jar %s", file, jar, jar
            ))
          end, "Kotlin: Compile & run")
          map("<leader>ks", function()
            vim.cmd(string.format("!kotlinc-jvm -script %s", vim.fn.expand("%")))
          end, "Kotlin: Run as script")
        end,
      })
    end,
  },
}
