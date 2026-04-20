-- ─────────────────────────────────────────────
--  core/options.lua  –  Editor behaviour
-- ─────────────────────────────────────────────

local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"          -- always show gutter
opt.cursorline     = true
opt.termguicolors  = true
opt.showmode       = false          -- lualine handles this
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.splitbelow     = true
opt.splitright     = true
opt.laststatus     = 3              -- global statusline
opt.cmdheight      = 1
opt.pumheight      = 12            -- completion popup max items
opt.pumblend       = 5             -- slight transparency in popup

-- Tabs / Indent
opt.expandtab      = true
opt.shiftwidth     = 4
opt.tabstop        = 4
opt.softtabstop    = 4
opt.smartindent    = true
opt.autoindent     = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- Files
opt.undofile       = true           -- persistent undo
opt.backup         = false
opt.swapfile       = false
opt.fileencoding   = "utf-8"
opt.autoread       = true

-- Performance
opt.updatetime     = 200
opt.timeoutlen     = 300

-- Clipboard
opt.clipboard      = "unnamedplus"  -- sync with system clipboard

-- Appearance
opt.list           = true
opt.listchars      = { tab = "→ ", trail = "·", nbsp = "␣" }
opt.fillchars      = {
  eob   = " ",                      -- hide ~ on empty lines
  fold  = " ",
  vert  = "│",
}

-- Folds (nvim-ufo handles this)
opt.foldcolumn     = "1"
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldenable     = true

-- Mouse
opt.mouse          = "a"
