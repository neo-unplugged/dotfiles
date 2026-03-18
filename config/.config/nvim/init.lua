-- ============================================================
--  init.lua — Entry point
--  Load order matters: options → keymaps → autocmds → plugins
-- ============================================================

require("config.options")   -- Editor options (tabs, UI, netrw disable)
require("config.keymaps")   -- Vanilla Neovim keymaps only
require("config.autocmds")  -- Auto-commands
require("config.lazy")      -- Plugin manager bootstrap
