-- ─────────────────────────────────────────────
--  core/keymaps.lua  –  VSCode-like keybindings
-- ─────────────────────────────────────────────

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── General ──────────────────────────────────
map("i", "jk", "<ESC>",                              opts)               -- fast escape
map("n", "<Esc>", "<cmd>noh<CR>",                    opts)               -- clear search highlight
map("n", "<C-s>", "<cmd>w<CR>",                      opts)               -- Ctrl+S save
map("i", "<C-s>", "<Esc><cmd>w<CR>",                 opts)               -- Ctrl+S save (insert mode)
map("n", "<C-z>", "u",                               opts)               -- Ctrl+Z undo
map("n", "<C-y>", "<C-r>",                           opts)               -- Ctrl+Y redo

-- ── Sidebar (NvimTree) ────────────────────────
--  Ctrl+B toggles the sidebar from ANY mode, just like VSCode.
--  Each mode needs its own escape sequence before the command:
--    normal  → run command directly
--    insert  → exit insert first (Esc), then run
--    visual  → run command directly (selection is dropped)
--    terminal→ exit terminal mode (C-\ C-n), then run
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>",            opts)            -- normal mode
map("i", "<C-b>", "<Esc><cmd>NvimTreeToggle<CR>",       opts)            -- insert mode
map("t", "<C-b>", "<C-\\><C-n><cmd>NvimTreeToggle<CR>", opts)            -- terminal mode

map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>",      opts)               -- focus sidebar (move cursor into it)

-- ── Tabs / Buffers (like VSCode tabs) ────────
map("n", "<C-Tab>",   "<cmd>bnext<CR>",              opts)               -- next buffer
map("n", "<C-S-Tab>", "<cmd>bprev<CR>",              opts)               -- prev buffer
map("n", "<leader>x", "<cmd>Bdelete<CR>",            opts)               -- close buffer (keeps window layout)
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", opts)           -- jump to buffer 1
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", opts)           -- jump to buffer 2
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", opts)           -- jump to buffer 3
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", opts)           -- jump to buffer 4
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", opts)           -- jump to buffer 5

-- ── Splits / Windows ─────────────────────────
map("n", "<C-h>", "<C-w>h",                          opts)               -- move to left split
map("n", "<C-j>", "<C-w>j",                          opts)               -- move to split below
map("n", "<C-k>", "<C-w>k",                          opts)               -- move to split above
map("n", "<C-l>", "<C-w>l",                          opts)               -- move to right split
map("n", "<leader>\\", "<cmd>vsplit<CR>",            opts)               -- vertical split
map("n", "<leader>-",  "<cmd>split<CR>",             opts)               -- horizontal split

-- ── Telescope (Ctrl+P like VSCode) ───────────
map("n", "<C-p>",      "<cmd>Telescope find_files<CR>",           opts)  -- find files
map("n", "<C-S-p>",    "<cmd>Telescope commands<CR>",             opts)  -- command palette
map("n", "<C-f>",      "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts) -- search in file
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",           opts)  -- find files
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",            opts)  -- grep in project
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",              opts)  -- open buffers
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", opts)  -- document symbols
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",             opts)  -- recent files

-- ── LSP ──────────────────────────────────────
--  Per-buffer keymaps are set in plugins/lsp.lua via LspAttach.
--  These are global fallbacks active before any LSP attaches.
map("n", "K",          vim.lsp.buf.hover,                         opts)  -- hover docs
map("n", "gd",         vim.lsp.buf.definition,                    opts)  -- go to definition
map("n", "gD",         vim.lsp.buf.declaration,                   opts)  -- go to declaration
map("n", "gi",         vim.lsp.buf.implementation,                opts)  -- go to implementation
map("n", "gr",         "<cmd>Telescope lsp_references<CR>",       opts)  -- references
map("n", "<leader>rn", vim.lsp.buf.rename,                        opts)  -- rename symbol
map("n", "<F2>",       vim.lsp.buf.rename,                        opts)  -- rename symbol (VSCode F2)
map("n", "<leader>ca", vim.lsp.buf.code_action,                   opts)  -- code action
map("n", "<C-.>",      vim.lsp.buf.code_action,                   opts)  -- code action (VSCode Ctrl+.)
map("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end, opts) -- format file
map("n", "<S-A-f>",    function() vim.lsp.buf.format({ async = true }) end, opts) -- format (VSCode Shift+Alt+F)

-- ── Diagnostics ───────────────────────────────
map("n", "[d",        vim.diagnostic.goto_prev,                   opts)  -- previous diagnostic
map("n", "]d",        vim.diagnostic.goto_next,                   opts)  -- next diagnostic
map("n", "<leader>d", "<cmd>Telescope diagnostics<CR>",           opts)  -- all diagnostics

-- ── Terminal ──────────────────────────────────
--  Ctrl+` mirrors VSCode's integrated terminal toggle.
--  The terminal mode mapping lets you close it without switching modes first.
map("n", "<C-`>", "<cmd>ToggleTerm<CR>",             opts)               -- toggle terminal (normal)
map("t", "<C-`>", "<cmd>ToggleTerm<CR>",             opts)               -- toggle terminal (terminal mode)
map("t", "<Esc>", "<C-\\><C-n>",                     opts)               -- exit terminal mode

-- ── Move lines (Alt+J/K like VSCode Alt+↑/↓) ─
map("n", "<A-j>", "<cmd>m .+1<CR>==",               opts)               -- move line down
map("n", "<A-k>", "<cmd>m .-2<CR>==",               opts)               -- move line up
map("v", "<A-j>", ":m '>+1<CR>gv=gv",              opts)               -- move selection down
map("v", "<A-k>", ":m '<-2<CR>gv=gv",              opts)               -- move selection up

-- ── Comment (Ctrl+/) ─────────────────────────
map("n", "<C-/>", "gcc",                            { remap = true })   -- toggle line comment
map("v", "<C-/>", "gc",                             { remap = true })   -- toggle block comment

-- ── Indentation (Tab / Shift+Tab in visual) ──
map("v", "<Tab>",   ">gv",                           opts)               -- indent and reselect
map("v", "<S-Tab>", "<gv",                           opts)               -- unindent and reselect

-- ── Misc ──────────────────────────────────────
map("n", "<leader>h", "<cmd>checkhealth<CR>",        opts)               -- health check
map("n", "<leader>L", "<cmd>Lazy<CR>",               opts)               -- open Lazy plugin manager
map("n", "<leader>M", "<cmd>Mason<CR>",              opts)               -- open Mason installer
