-- ============================================================
--  plugins/completion.lua — nvim-cmp + LuaSnip (VSCode feel)
-- ============================================================

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Sources
      "hrsh7th/cmp-nvim-lsp",           -- LSP completions
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",             -- words in buffer
      "hrsh7th/cmp-path",               -- filesystem paths
      "hrsh7th/cmp-cmdline",            -- : and / cmdline
      "saadparwaiz1/cmp_luasnip",       -- snippet completions
      -- Snippets engine
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",   -- VSCode-style snippet library
      -- Pictograms (VSCode icons in popup)
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load VSCode-style snippets (friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- ── Keybinds (VSCode-style) ────────────────────────
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),        -- trigger completion
          ["<CR>"]      = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select   = true,                            -- accept first if none selected
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-n>"]   = cmp.mapping.select_next_item(),
          ["<C-p>"]   = cmp.mapping.select_prev_item(),
          ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),
          ["<C-e>"]   = cmp.mapping.abort(),
        }),

        -- ── Sources (priority order) ───────────────────────
        sources = cmp.config.sources({
          { name = "nvim_lsp",               priority = 1000 },
          { name = "nvim_lsp_signature_help",priority = 900  },
          { name = "luasnip",                priority = 750  },
          { name = "buffer",                 priority = 500  },
          { name = "path",                   priority = 250  },
        }),

        -- ── VSCode-style icons ─────────────────────────────
        formatting = {
          format = lspkind.cmp_format({
            mode         = "symbol_text",
            maxwidth     = 50,
            ellipsis_char = "…",
            before = function(entry, vim_item)
              -- Show source name
              vim_item.menu = ({
                nvim_lsp    = "[LSP]",
                luasnip     = "[Snip]",
                buffer      = "[Buf]",
                path        = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },

        -- Don't complete in comments
        enabled = function()
          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then return true end
          return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
        end,

        experimental = {
          ghost_text = { hl_group = "CmpGhostText" },  -- inline preview
        },
      })

      -- ── Cmdline completions ────────────────────────────
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })

      -- Ghost text highlight
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    end,
  },

  -- ── LuaSnip standalone ───────────────────────────────────
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy  = true,
  },
}
