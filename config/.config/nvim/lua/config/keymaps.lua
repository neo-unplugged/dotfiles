-- ============================================================
--  config/keymaps.lua — Vanilla Neovim keymaps only
--  Plugin-specific maps live in each plugin's keys = {} table
--  LSP maps live in plugins/lsp/init.lua (LspAttach autocmd)
-- ============================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── Leader ────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Save & Quit ───────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>",   "<Esc>:w<CR>",   vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n",               "<C-q>",   ":q<CR>",         vim.tbl_extend("force", opts, { desc = "Quit" }))
map("n",               "<C-S-q>", ":qa!<CR>",       vim.tbl_extend("force", opts, { desc = "Force quit all" }))

-- ── Undo / Redo ───────────────────────────────────────────
map({ "n", "i" }, "<C-z>", "<Esc>u",      vim.tbl_extend("force", opts, { desc = "Undo" }))
map({ "n", "i" }, "<C-y>", "<Esc><C-r>",  vim.tbl_extend("force", opts, { desc = "Redo" }))

-- ── Clipboard ─────────────────────────────────────────────
map({ "n", "v" }, "<C-c>", '"+y',        vim.tbl_extend("force", opts, { desc = "Copy to clipboard" }))
map({ "n", "v" }, "<C-v>", '"+p',        vim.tbl_extend("force", opts, { desc = "Paste from clipboard" }))
map("i",          "<C-v>", "<C-r>+",     vim.tbl_extend("force", opts, { desc = "Paste in insert mode" }))
map({ "n", "v" }, "<C-x>", '"+d',        vim.tbl_extend("force", opts, { desc = "Cut to clipboard" }))

-- ── Select All ────────────────────────────────────────────
map("n", "<C-a>", "ggVG", vim.tbl_extend("force", opts, { desc = "Select all" }))

-- ── Find & Replace ────────────────────────────────────────
map("n", "<C-h>", ":%s/",  { noremap = true, desc = "Find & replace" })
map("n", "<C-f>", "/",     vim.tbl_extend("force", opts, { desc = "Search in file" }))

-- ── Buffer Management ─────────────────────────────────────
map("n", "<C-Tab>",   ":bnext<CR>",     vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<C-S-Tab>", ":bprevious<CR>", vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
map("n", "<C-w>",     ":bdelete<CR>",   vim.tbl_extend("force", opts, { desc = "Close buffer" }))

-- ── Split Management ──────────────────────────────────────
map("n", "<C-\\>v",   ":vsplit<CR>",  vim.tbl_extend("force", opts, { desc = "Vertical split" }))
map("n", "<C-\\>h",   ":split<CR>",   vim.tbl_extend("force", opts, { desc = "Horizontal split" }))
map("n", "<C-Left>",  "<C-w>h",       vim.tbl_extend("force", opts, { desc = "Move to left pane" }))
map("n", "<C-Right>", "<C-w>l",       vim.tbl_extend("force", opts, { desc = "Move to right pane" }))
map("n", "<C-Up>",    "<C-w>k",       vim.tbl_extend("force", opts, { desc = "Move to upper pane" }))
map("n", "<C-Down>",  "<C-w>j",       vim.tbl_extend("force", opts, { desc = "Move to lower pane" }))

-- ── Move Lines (Alt+Up/Down) ──────────────────────────────
map("n", "<A-Up>",   ":m .-2<CR>==",   vim.tbl_extend("force", opts, { desc = "Move line up" }))
map("n", "<A-Down>", ":m .+1<CR>==",   vim.tbl_extend("force", opts, { desc = "Move line down" }))
map("v", "<A-Up>",   ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))

-- ── Indentation ───────────────────────────────────────────
map("v", "<Tab>",   ">gv", vim.tbl_extend("force", opts, { desc = "Indent selection" }))
map("v", "<S-Tab>", "<gv", vim.tbl_extend("force", opts, { desc = "Unindent selection" }))

-- ── Duplicate Line ────────────────────────────────────────
map("n", "<A-S-Down>", "yyp",   vim.tbl_extend("force", opts, { desc = "Duplicate line" }))
map("v", "<A-S-Down>", "y'>p",  vim.tbl_extend("force", opts, { desc = "Duplicate selection" }))

-- ── Clear Search Highlight ────────────────────────────────
map("n", "<Esc>", ":nohl<CR>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))

-- ── Terminal escape ───────────────────────────────────────
map("t", "<Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Escape terminal mode" }))
