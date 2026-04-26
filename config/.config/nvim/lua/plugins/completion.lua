-- ─────────────────────────────────────────────
--  plugins/completion.lua  –  nvim-cmp + snippets
-- ─────────────────────────────────────────────

return {
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- Snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local kind_icons = {
        Text          = "󰉿", Method        = "󰆧", Function      = "󰊕",
        Constructor   = "",  Field         = "󰜢", Variable      = "󰀫",
        Class         = "󰠱", Interface     = "",  Module        = "",
        Property      = "󰜢", Unit          = "󰑭", Value         = "󰎠",
        Enum          = "",  Keyword       = "󰌋", Snippet       = "",
        Color         = "󰏘", File          = "󰈙", Reference     = "󰈇",
        Folder        = "󰉋", EnumMember    = "",  Constant      = "󰏿",
        Struct        = "󰙅", Event         = "",  Operator      = "󰆕",
        TypeParameter = "",
      }

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },

        window = {
          completion    = cmp.config.window.bordered({ border = "rounded", scrollbar = false }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"]  = cmp.mapping.complete(),
          ["<CR>"]       = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]      = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]    = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<C-b>"]      = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]      = cmp.mapping.scroll_docs(4),
          ["<C-e>"]      = cmp.mapping.abort(),
          ["<Down>"]     = cmp.mapping.select_next_item(),
          ["<Up>"]       = cmp.mapping.select_prev_item(),
        }),

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.kind   = string.format("%s %s", kind_icons[item.kind] or "?", item.kind)
            item.menu   = ({
              nvim_lsp  = "[LSP]",
              luasnip   = "[Snip]",
              buffer    = "[Buf]",
              path      = "[Path]",
            })[entry.source.name] or ""
            if #item.abbr > 40 then item.abbr = item.abbr:sub(1, 40) .. "…" end
            return item
          end,
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp",               priority = 1000 },
          { name = "nvim_lsp_signature_help",priority = 900 },
          { name = "luasnip",                priority = 800 },
          { name = "path",                   priority = 700 },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),

        experimental = { ghost_text = true },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },
}
