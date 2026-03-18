-- ============================================================
--  plugins/git.lua — Git integration (gutter, status, diff)
-- ============================================================

return {
  -- ── Gitsigns: VSCode-style gutter indicators ─────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signcolumn         = true,
      numhl              = false,
      linehl             = false,
      word_diff          = false,
      current_line_blame = true,   -- Inline blame like VSCode GitLens
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        -- Hunk navigation
        map("n", "]c", gs.next_hunk,            "Next git hunk")
        map("n", "[c", gs.prev_hunk,            "Prev git hunk")
        -- Hunk actions
        map("n", "<leader>hs", gs.stage_hunk,   "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis,     "Diff this")
      end,
    },
  },

  -- ── Neogit: Magit-style Git client ──────────────────────
  {
    "NeogitOrg/neogit",
    cmd          = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit<CR>", desc = "Git status" },
    },
    opts = {
      kind         = "split",
      integrations = { diffview = true, telescope = true },
      signs = {
        section = { "", "" },
        item    = { "", "" },
        hunk    = { "", "" },
      },
    },
  },

  -- ── Diffview: side-by-side diffs ────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff view" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default      = { layout = "diff2_horizontal" },
        merge_tool   = { layout = "diff3_horizontal" },
        file_history = { layout = "diff2_horizontal" },
      },
    },
  },
}
