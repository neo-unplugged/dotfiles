-- ============================================================
--  config/keymaps.lua — VSCode-style keybindings
-- ============================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── Leader ────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Save & Quit ───────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>",   "<Esc>:w<CR>",   vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n",               "<C-q>",   ":q<CR>",         vim.tbl_extend("force", opts, { desc = "Quit" }))
map("n",               "<C-S-q>", ":qa!<CR>",        vim.tbl_extend("force", opts, { desc = "Force quit all" }))

-- ── Undo / Redo (VSCode style) ────────────────────────────
map({ "n", "i" }, "<C-z>", "<Esc>u",      vim.tbl_extend("force", opts, { desc = "Undo" }))
map({ "n", "i" }, "<C-y>", "<Esc><C-r>",  vim.tbl_extend("force", opts, { desc = "Redo" }))

-- ── Copy / Paste ──────────────────────────────────────────
map({ "n", "v" }, "<C-c>", '"+y',       vim.tbl_extend("force", opts, { desc = "Copy to clipboard" }))
map({ "n", "v" }, "<C-v>", '"+p',       vim.tbl_extend("force", opts, { desc = "Paste from clipboard" }))
map("i",          "<C-v>", "<C-r>+",    vim.tbl_extend("force", opts, { desc = "Paste in insert mode" }))
map({ "n", "v" }, "<C-x>", '"+d',       vim.tbl_extend("force", opts, { desc = "Cut to clipboard" }))

-- ── Select All ────────────────────────────────────────────
map("n", "<C-a>", "ggVG", vim.tbl_extend("force", opts, { desc = "Select all" }))

-- ── Find & Replace ────────────────────────────────────────
map("n", "<C-h>", ":%s/",  { noremap = true, desc = "Find & replace" })
map("n", "<C-f>", "/",     vim.tbl_extend("force", opts, { desc = "Search in file" }))

-- ── Buffer Management ─────────────────────────────────────
-- NOTE: <C-w> is intentionally left free — it's Neovim's window management prefix
map("n", "<C-Tab>",   ":bnext<CR>",      vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<C-S-Tab>", ":bprevious<CR>",  vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
-- bufdelete.nvim handles these — see plugins/editor.lua
-- <leader>bd and <leader>bD are defined there via keys table

-- ── Split navigation ──────────────────────────────────────
map("n", "<C-\\>v",   ":vsplit<CR>",  vim.tbl_extend("force", opts, { desc = "Vertical split" }))
map("n", "<C-\\>h",   ":split<CR>",   vim.tbl_extend("force", opts, { desc = "Horizontal split" }))
map("n", "<C-Left>",  "<C-w>h",       vim.tbl_extend("force", opts, { desc = "Move to left pane" }))
map("n", "<C-Right>", "<C-w>l",       vim.tbl_extend("force", opts, { desc = "Move to right pane" }))
map("n", "<C-Up>",    "<C-w>k",       vim.tbl_extend("force", opts, { desc = "Move to upper pane" }))
map("n", "<C-Down>",  "<C-w>j",       vim.tbl_extend("force", opts, { desc = "Move to lower pane" }))

-- ── File Explorer (Ctrl+E like VSCode sidebar) ────────────
map("n", "<C-e>", function()
  local api  = require("nvim-tree.api")
  local view = require("nvim-tree.view")
  if view.is_visible() then
    api.tree.close()
  else
    api.tree.open()
    vim.cmd("wincmd p")
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle file explorer" }))

-- ── Fuzzy Search (Ctrl+P like VSCode) ────────────────────
map("n", "<C-p>",      ":Telescope find_files<CR>",           vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "<C-S-f>",    ":Telescope live_grep<CR>",            vim.tbl_extend("force", opts, { desc = "Search in project" }))
map("n", "<C-S-p>",    ":Telescope commands<CR>",             vim.tbl_extend("force", opts, { desc = "Command palette" }))
map("n", "<leader>fb", ":Telescope buffers<CR>",              vim.tbl_extend("force", opts, { desc = "Find buffers" }))
map("n", "<leader>fr", ":Telescope oldfiles<CR>",             vim.tbl_extend("force", opts, { desc = "Recent files" }))
map("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", vim.tbl_extend("force", opts, { desc = "Symbols" }))

-- ── LSP (VSCode-style) ────────────────────────────────────
map("n", "gd",         vim.lsp.buf.definition,                          vim.tbl_extend("force", opts, { desc = "Go to definition" }))
map("n", "gD",         vim.lsp.buf.declaration,                         vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
map("n", "gr",         vim.lsp.buf.references,                          vim.tbl_extend("force", opts, { desc = "Find references" }))
map("n", "gi",         vim.lsp.buf.implementation,                      vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
map("n", "<F12>",      vim.lsp.buf.definition,                          vim.tbl_extend("force", opts, { desc = "Go to definition" }))
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
                                                                         vim.tbl_extend("force", opts, { desc = "Format document" }))
map("n", "<leader>ld", vim.diagnostic.open_float,                       vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
map("n", "]d",         vim.diagnostic.goto_next,                        vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
map("n", "[d",         vim.diagnostic.goto_prev,                        vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))

-- ── Git ───────────────────────────────────────────────────
map("n", "<leader>gs", ":Neogit<CR>",                vim.tbl_extend("force", opts, { desc = "Git status" }))
map("n", "<leader>gb", ":Telescope git_branches<CR>",vim.tbl_extend("force", opts, { desc = "Git branches" }))
map("n", "<leader>gc", ":Telescope git_commits<CR>", vim.tbl_extend("force", opts, { desc = "Git commits" }))
map("n", "<leader>gd", ":DiffviewOpen<CR>",          vim.tbl_extend("force", opts, { desc = "Git diff view" }))

-- ── Terminal (Ctrl+` like VSCode) ─────────────────────────
map("n", "<C-`>", ":ToggleTerm<CR>",  vim.tbl_extend("force", opts, { desc = "Toggle terminal" }))
map("t", "<Esc>", "<C-\\><C-n>",      vim.tbl_extend("force", opts, { desc = "Escape terminal" }))

-- ── Move lines (Alt+Up/Down like VSCode) ──────────────────
map("n", "<A-Up>",   ":m .-2<CR>==",       vim.tbl_extend("force", opts, { desc = "Move line up" }))
map("n", "<A-Down>", ":m .+1<CR>==",       vim.tbl_extend("force", opts, { desc = "Move line down" }))
map("v", "<A-Up>",   ":m '<-2<CR>gv=gv",  vim.tbl_extend("force", opts, { desc = "Move selection up" }))
map("v", "<A-Down>", ":m '>+1<CR>gv=gv",  vim.tbl_extend("force", opts, { desc = "Move selection down" }))

-- ── Indentation (Tab in visual like VSCode) ───────────────
map("v", "<Tab>",   ">gv", vim.tbl_extend("force", opts, { desc = "Indent selection" }))
map("v", "<S-Tab>", "<gv", vim.tbl_extend("force", opts, { desc = "Unindent selection" }))

-- ── Clear search highlight ────────────────────────────────
map("n", "<Esc>", ":nohl<CR>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))

-- ── Duplicate line (Alt+Shift+Down like VSCode) ───────────
map("n", "<A-S-Down>", "yyp",   vim.tbl_extend("force", opts, { desc = "Duplicate line" }))
map("v", "<A-S-Down>", "y'>p",  vim.tbl_extend("force", opts, { desc = "Duplicate selection" }))
