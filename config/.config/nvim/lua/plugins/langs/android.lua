-- ─────────────────────────────────────────────
--  plugins/langs/android.lua  –  Android workload pack
--
--  Android-specific extras ONLY: Gradle build,
--  ADB commands, Android DAP config, device tests.
--
--  Requires kotlin.lua to also be enabled —
--  this pack does NOT re-declare the Kotlin LSP,
--  ktlint, neotest, or syntax plugin.
--
--  Enable BOTH in lazy.lua:
--    { import = "plugins.langs.kotlin" },
--    { import = "plugins.langs.android" },
-- ─────────────────────────────────────────────

return {
  -- ── Android DAP config ────────────────────────
  --  Adapter is declared in kotlin.lua.
  --  This just swaps the launch config for Android.
  {
    "mfussenegger/nvim-dap",
    ft = { "kotlin" },
    config = function()
      local dap = require("dap")
      dap.configurations.kotlin = {
        {
          type        = "kotlin",
          request     = "launch",
          name        = "Android Debug",
          projectRoot = "${workspaceFolder}",
          mainClass   = function()
            return vim.fn.input("Main class: ", "com.example.MainActivityKt")
          end,
        },
      }
    end,
  },

  -- ── Android / Gradle / ADB keymaps ───────────
  {
    "udalov/kotlin-vim",
    ft = { "kotlin" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "kotlin",
        group    = vim.api.nvim_create_augroup("AndroidKeymaps", { clear = true }),
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>ab", "<cmd>!./gradlew assembleDebug<CR>",             "Android: Build debug")
          map("<leader>ai", "<cmd>!./gradlew installDebug<CR>",              "Android: Install debug")
          map("<leader>ar", "<cmd>!./gradlew connectedDebugAndroidTest<CR>", "Android: Run device tests")
          map("<leader>al", "<cmd>!adb logcat<CR>",                          "Android: ADB logcat")
          map("<leader>ac", "<cmd>!adb logcat -c<CR>",                       "Android: Clear ADB logs")
          map("<leader>ad", "<cmd>!adb devices<CR>",                         "Android: List ADB devices")
        end,
      })
    end,
  },
}
