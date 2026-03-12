-- ============================================================
--  config/lazy.lua — lazy.nvim bootstrap + plugin loading
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },           -- loads all files in lua/plugins/
  },
  defaults = { lazy = true },         -- lazy-load everything by default
  install  = { colorscheme = { "tokyonight" } },
  ui = {
    border = "rounded",
    icons  = {
      package = "📦", loaded = "✓", not_loaded = "○",
    },
  },
  checker = { enabled = true, notify = false }, -- auto-check for updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "netrwPlugin", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})
