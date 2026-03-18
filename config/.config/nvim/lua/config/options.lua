-- ============================================================
--  config/options.lua — Core editor settings (VSCode feel)
-- ============================================================

local opt = vim.opt

-- ── Disable netrw (must be before any plugin loads it) ────
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- ── Nerd Font ─────────────────────────────────────────────
vim.g.have_nerd_font = true   -- tells plugins icons are available

-- ── UI ────────────────────────────────────────────────────
opt.number         = true          -- Line numbers
opt.relativenumber = false         -- Absolute numbers (like VSCode)
opt.signcolumn     = "yes"         -- Always show sign column (no layout jump)
opt.cursorline     = true          -- Highlight current line
opt.termguicolors  = true          -- True-color support
opt.showmode       = false         -- Mode shown in statusline instead
opt.cmdheight      = 1
opt.pumheight      = 10            -- Max items in completion popup
opt.scrolloff      = 8             -- Keep 8 lines above/below cursor
opt.sidescrolloff  = 8
opt.wrap           = false         -- No line wrap (VSCode default)
opt.colorcolumn    = ""            -- No color column
opt.laststatus     = 3             -- Global statusline

-- ── Tabs & Indentation ────────────────────────────────────
opt.tabstop        = 2             -- 2-space tabs (VSCode default)
opt.shiftwidth     = 2
opt.softtabstop    = 2
opt.expandtab      = true          -- Spaces, not tabs
opt.smartindent    = true
opt.autoindent     = true

-- ── Search ────────────────────────────────────────────────
opt.ignorecase     = true          -- Case-insensitive search
opt.smartcase      = true          -- Unless uppercase typed
opt.hlsearch       = true
opt.incsearch      = true

-- ── Files & Backup ────────────────────────────────────────
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true          -- Persistent undo
opt.undodir        = vim.fn.stdpath("data") .. "/undodir"
opt.autoread       = true          -- Auto-reload changed files

-- ── Splits ────────────────────────────────────────────────
opt.splitbelow     = true          -- Horizontal split goes below
opt.splitright     = true          -- Vertical split goes right

-- ── Performance ───────────────────────────────────────────
opt.updatetime     = 200           -- Faster CursorHold events
opt.timeoutlen     = 300           -- Faster key sequence timeout

-- ── Clipboard ─────────────────────────────────────────────
opt.clipboard      = "unnamedplus" -- Sync with system clipboard

-- ── Completion ────────────────────────────────────────────
opt.completeopt    = { "menu", "menuone", "noselect" }

-- ── Folding (uses built-in treesitter, nvim 0.10+) ────────
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel      = 99            -- Open all folds by default
opt.foldtext       = ""            -- Use syntax-highlighted fold line

-- ── Misc ──────────────────────────────────────────────────
opt.mouse          = "a"           -- Enable mouse support
opt.conceallevel   = 0
opt.fileencoding   = "utf-8"
opt.backspace      = { "indent", "eol", "start" }
