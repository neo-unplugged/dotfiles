-- ─────────────────────────────────────────────
--  core/lazy.lua  –  Plugin manager bootstrap
-- ─────────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Detect Termux (Android) — disables packs that need desktop binaries
local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1

require("lazy").setup({
  -- ── Core infrastructure ──────────────────────
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },         -- LSP infra only (mason, none-ls, fidget)
  { import = "plugins.completion" },
  { import = "plugins.treesitter" },
  { import = "plugins.tools" },       -- Generic tools only (DAP core, lazygit, spectre, neotest)

  -- ── Language / workload packs ────────────────
  --  Works on both desktop and Termux.
  --  Packs guarded by `not is_termux` are skipped on Termux
  --  because they need lldb-vscode, adb, or gradlew.
  { import = "plugins.langs.go" },
  { import = "plugins.langs.python" },
  { import = "plugins.langs.web" },
  { import = "plugins.langs.lua_lang" },
  { import = "plugins.langs.kotlin" },                                      -- works on Termux
  not is_termux and { import = "plugins.langs.rust" }    or nil,            -- needs lldb-vscode
  not is_termux and { import = "plugins.langs.c" }       or nil,            -- needs lldb-vscode
  not is_termux and { import = "plugins.langs.android" } or nil,            -- needs adb + gradlew
  -- { import = "plugins.langs.zig" },                                      -- uncomment to add Zig
}, {
  defaults = { lazy = true },
  install  = { colorscheme = { "catppuccin" } },
  checker  = { enabled = true, notify = false },
  ui       = { border = "rounded" },
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
    git = { timeout = 180 },
  },
})
