-- ============================================================
--  config/autocmds.lua — Auto-commands
-- ============================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Highlight on yank ─────────────────────────────────────
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- ── Restore cursor position ───────────────────────────────
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── Auto-resize splits on window resize ───────────────────
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group   = "ResizeSplits",
  command = "tabdo wincmd =",
})

-- ── Remove trailing whitespace on save ────────────────────
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group   = "TrimWhitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ── Auto-close NvimTree if last window ────────────────────
augroup("NvimTreeAutoClose", { clear = true })
autocmd("BufEnter", {
  group    = "NvimTreeAutoClose",
  nested   = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1
      and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd("quit")
    end
  end,
})

-- ── Format on save handled by conform.nvim (plugins/formatting.lua)
