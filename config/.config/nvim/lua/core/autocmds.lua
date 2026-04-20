-- ─────────────────────────────────────────────
--  core/autocmds.lua  –  Auto-commands
-- ─────────────────────────────────────────────

local au  = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup

-- Highlight text on yank
au("TextYankPost", {
  group    = aug("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

-- Restore cursor position
au("BufReadPost", {
  group = aug("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Close some filetypes with just 'q'
au("FileType", {
  group   = aug("CloseWithQ", { clear = true }),
  pattern = { "help", "man", "qf", "lspinfo", "notify", "startuptime", "checkhealth" },
  callback = function(e)
    vim.bo[e.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = e.buf, silent = true })
  end,
})

-- Auto-format on save (opt-in per filetype)
au("BufWritePre", {
  group   = aug("AutoFormat", { clear = true }),
  pattern = { "*.go", "*.rs", "*.c", "*.cpp", "*.h", "*.lua" },
  callback = function() vim.lsp.buf.format({ async = false }) end,
})

-- Trim trailing whitespace
au("BufWritePre", {
  group   = aug("TrimWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Set indentation per language
au("FileType", {
  group   = aug("Indentation", { clear = true }),
  pattern = { "go" },
  callback = function()
    vim.bo.expandtab  = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop    = 4
  end,
})
au("FileType", {
  group   = aug("Indentation2", { clear = true }),
  pattern = { "lua", "yaml", "json", "html", "css", "javascript", "typescript" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
  end,
})

-- Check if file changed outside of neovim
au({ "FocusGained", "BufEnter", "CursorHold" }, {
  group    = aug("Checktime", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then vim.cmd("checktime") end
  end,
})
