-- ============================================================
--  plugins/treesitter.lua — Syntax highlighting + text objects
-- ============================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    main         = "nvim-treesitter",   -- tells lazy to call require("nvim-treesitter").setup(opts)
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "go", "gomod", "gosum", "gotmpl",
        "rust",
        "c", "cpp", "cmake",
        "python",
        "bash",
        "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "html", "css", "javascript", "typescript",
        "regex", "diff",
      },
      highlight             = { enable = true },
      indent                = { enable = true },
      incremental_selection = {
        enable  = true,
        keymaps = {
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          scope_incremental = false,
          node_decremental  = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps   = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable              = true,
          set_jumps           = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable        = true,
          swap_next     = { ["<leader>a"] = "@parameter.inner" },
          swap_previous = { ["<leader>A"] = "@parameter.inner" },
        },
      },
    },
  },
}
