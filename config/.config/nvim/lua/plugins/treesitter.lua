-- ─────────────────────────────────────────────
--  plugins/treesitter.lua  –  nvim-treesitter v1.0+
-- ─────────────────────────────────────────────

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    -- CHANGED: VeryLazy instead of BufReadPost (non-critical for editing)
    event  = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "go", "gomod", "gosum", "gowork",
        "c", "cpp",
        "rust",
        "lua", "vim", "vimdoc",
        "python",
        "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml",
        "bash", "markdown", "markdown_inline",
        "gitignore", "gitcommit",
      },

      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent    = { enable = true },
      autotag   = { enable = true },

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
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable              = true,
          set_jumps           = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
        swap = {
          enable        = true,
          swap_next     = { ["<leader>sn"] = "@parameter.inner" },
          swap_previous = { ["<leader>sp"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      require("treesitter-context").setup({ max_lines = 3 })
      require("ts_context_commentstring").setup({ enable_autocmd = false })
    end,
  },
}
