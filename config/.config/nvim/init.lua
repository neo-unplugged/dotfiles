-- ============================================================
--  init.lua — VSCode-like Neovim config
--  Entry point: loads core settings, keymaps, then plugins
-- ============================================================

require("config.options")   -- Editor options (tabs, UI, etc.)
require("config.keymaps")   -- VSCode-style keybindings
require("config.autocmds")  -- Auto-commands
require("config.lazy")      -- Plugin manager bootstrap
