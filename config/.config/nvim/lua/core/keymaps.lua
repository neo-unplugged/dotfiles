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
map("i", "<C-s>", "<Esc><cmd>w<CR>",                 opts)
map("n", "<C-z>", "u",                               opts)               -- Ctrl+Z undo
map("n", "<C-y>", "<C-r>",                           opts)               -- Ctrl+Y redo

-- ── Sidebar (NvimTree) ────────────────────────
map("n", "<C-b>",     "<cmd>NvimTreeToggle<CR>",     opts)               -- toggle sidebar
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>",      opts)               -- focus sidebar

-- ── Tabs / Buffers (like VSCode tabs) ────────
map("n", "<C-Tab>",   "<cmd>bnext<CR>",              opts)               -- next buffer
map("n", "<C-S-Tab>", "<cmd>bprev<CR>",              opts)               -- prev buffer
map("n", "<leader>x", "<cmd>Bdelete<CR>",            opts)               -- close tab (bufdelete)
map("n", "<C-w>",     "<cmd>Bdelete<CR>",            opts)               -- Ctrl+W close
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", opts)

-- ── Splits / Windows ─────────────────────────
map("n", "<C-h>", "<C-w>h",                          opts)               -- move left
map("n", "<C-j>", "<C-w>j",                          opts)               -- move down
map("n", "<C-k>", "<C-w>k",                          opts)               -- move up
map("n", "<C-l>", "<C-w>l",                          opts)               -- move right
map("n", "<leader>\\", "<cmd>vsplit<CR>",            opts)               -- vertical split
map("n", "<leader>-",  "<cmd>split<CR>",             opts)               -- horizontal split

-- ── Telescope (Ctrl+P like VSCode) ───────────
map("n", "<C-p>",      "<cmd>Telescope find_files<CR>",           opts)
map("n", "<C-S-p>",    "<cmd>Telescope commands<CR>",             opts)  -- command palette
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",           opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",            opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",              opts)
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", opts)
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",             opts)
map("n", "<C-f>",      "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)

-- ── LSP (set per-buffer in plugins/lsp.lua) ──
-- Global fallbacks:
map("n", "K",          vim.lsp.buf.hover,                         opts)
map("n", "gd",         vim.lsp.buf.definition,                    opts)
map("n", "gD",         vim.lsp.buf.declaration,                   opts)
map("n", "gi",         vim.lsp.buf.implementation,                opts)
map("n", "gr",         "<cmd>Telescope lsp_references<CR>",       opts)
map("n", "<leader>rn", vim.lsp.buf.rename,                        opts)  -- F2 rename
map("n", "<F2>",       vim.lsp.buf.rename,                        opts)
map("n", "<leader>ca", vim.lsp.buf.code_action,                   opts)  -- Ctrl+. code action
map("n", "<C-.>",      vim.lsp.buf.code_action,                   opts)
map("n", "<leader>f",  function() vim.lsp.buf.format({ async=true }) end, opts) -- format
map("n", "<S-A-f>",    function() vim.lsp.buf.format({ async=true }) end, opts) -- Shift+Alt+F

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev,                          opts)
map("n", "]d", vim.diagnostic.goto_next,                          opts)
map("n", "<leader>d", "<cmd>Telescope diagnostics<CR>",           opts)

-- ── Terminal ──────────────────────────────────
map("n", "<C-`>", "<cmd>ToggleTerm<CR>",             opts)               -- Ctrl+` like VSCode
map("t", "<C-`>", "<cmd>ToggleTerm<CR>",             opts)
map("t", "<Esc>", "<C-\\><C-n>",                     opts)               -- exit terminal mode

-- ── Move lines (Alt+↑/↓ like VSCode) ─────────
map("n", "<A-j>", "<cmd>m .+1<CR>==",               opts)
map("n", "<A-k>", "<cmd>m .-2<CR>==",               opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv",              opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv",              opts)

-- ── Comment (Ctrl+/) ─────────────────────────
map("n", "<C-/>", "gcc",                            { remap = true })
map("v", "<C-/>", "gc",                             { remap = true })

-- ── Indentation (Tab / Shift+Tab in visual) ──
map("v", "<Tab>",   ">gv",                           opts)
map("v", "<S-Tab>", "<gv",                           opts)

-- ── Misc ──────────────────────────────────────
map("n", "<leader>h", "<cmd>checkhealth<CR>",        opts)
map("n", "<leader>L", "<cmd>Lazy<CR>",               opts)               -- open Lazy UI
map("n", "<leader>M", "<cmd>Mason<CR>",              opts)               -- open Mason UI
