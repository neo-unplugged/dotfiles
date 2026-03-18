-- ============================================================
--  plugins/lsp/completion.lua — Autocompletion + Snippets
--
--  Stack:
--    nvim-cmp          — completion engine
--    LuaSnip           — snippet engine
--    friendly-snippets — VSCode snippet library (base)
--    lspkind           — pictograms
--
--  "Track inner definitions" strategy:
--    • LSP completions (cmp-nvim-lsp) give member/property suggestions
--      from the language server's type index — works for Go, Rust, C++,
--      TypeScript, Python out of the box via their LSPs.
--    • cmp-nvim-lsp-signature-help shows live parameter hints while typing.
--    • LuaSnip dynamic nodes let snippets query the buffer/LSP for
--      context, so e.g. struct/class field snippets adapt to the type.
--    • luasnip-snippets + custom ft-snippets cover language idioms.
-- ============================================================

return {
  -- ── Core completion engine ────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event        = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- LSP source — provides member/property completions
      "hrsh7th/cmp-nvim-lsp",
      -- Live function signature while typing args
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- Buffer words
      "hrsh7th/cmp-buffer",
      -- Filesystem paths
      "hrsh7th/cmp-path",
      -- Cmdline
      "hrsh7th/cmp-cmdline",
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- VSCode snippets library
      "rafamadriz/friendly-snippets",
      -- Language-specific snippet packs (Go, Rust, C++)
      "nvim-lua/plenary.nvim",   -- needed by some snippet loaders
      -- Pictograms
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local ls_types = require("luasnip.util.types")

      -- ── LuaSnip global config ───────────────────────────
      luasnip.config.setup({
        -- Show active snippet nodes highlighted
        ext_opts = {
          [ls_types.choiceNode] = {
            active = { virt_text = { { "⇥ choice", "Comment" } } },
          },
          [ls_types.insertNode] = {
            active = { virt_text = { { "●", "DiagnosticHint" } } },
          },
        },
        -- Keep last deleted snippet jumpable
        keep_roots           = true,
        link_roots           = true,
        link_children        = true,
        update_events        = { "TextChanged", "TextChangedI" },
        -- Re-use dynamic node results (performance)
        enable_autosnippets  = true,
        store_selection_keys = "<Tab>",
      })

      -- ── Snippet loaders ────────────────────────────────
      -- 1. VSCode-style JSON snippets (friendly-snippets covers most langs)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- 2. SnipMate-format .snippets files in config/snippets/
      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      -- 3. Lua-defined snippets (custom, loaded last for overrides)
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })

      -- ── Custom Lua snippets per language ───────────────
      -- These snippets use LuaSnip's full dynamic node API to inspect
      -- the current buffer/LSP context (e.g. variable type under cursor).
      local s   = luasnip.snippet
      local sn  = luasnip.snippet_node
      local t   = luasnip.text_node
      local i   = luasnip.insert_node
      local f   = luasnip.function_node
      local c   = luasnip.choice_node
      local d   = luasnip.dynamic_node
      local r   = luasnip.restore_node
      local fmt = require("luasnip.extras.fmt").fmt
      local rep = require("luasnip.extras").rep

      -- ── Go snippets ────────────────────────────────────
      luasnip.add_snippets("go", {
        -- if err != nil { return ..., err }
        s("ife", fmt([[
if err != nil {{
	return {}err
}}
]], { c(1, { t(""), t("nil, ") }) })),

        -- struct with auto-named fields
        s("st", fmt([[
type {} struct {{
	{}
}}
]], { i(1, "Name"), i(2, "Field Type") })),

        -- method on type
        s("meth", fmt([[
func ({}  *{}) {}({}) {} {{
	{}
}}
]], { i(1, "r"), rep(1), i(2, "Method"), i(3), i(4, "error"), i(5, "// TODO") })),

        -- goroutine + channel
        s("goch", fmt([[
ch := make(chan {}, {})
go func() {{
	defer close(ch)
	{}
}}()
]], { i(1, "int"), i(2, "1"), i(3, "// work") })),

        -- table-driven test
        s("ttest", fmt([[
func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
	}}{{
		{{
			name: "{}",
			{}
		}},
	}}
	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			{}
		}})
	}}
}}
]], { i(1, "Foo"), i(2, "input string"), i(3, "basic"), i(4, "// fields"), i(5, "// assert") })),
      })

      -- ── Rust snippets ──────────────────────────────────
      luasnip.add_snippets("rust", {
        -- impl block
        s("imp", fmt([[
impl {} {{
	{}
}}
]], { i(1, "Type"), i(2, "// methods") })),

        -- impl Trait for Type
        s("impt", fmt([[
impl {} for {} {{
	{}
}}
]], { i(1, "Trait"), i(2, "Type"), i(3, "// methods") })),

        -- derive macro
        s("der", fmt([[
#[derive({})]
]], { c(1, {
          t("Debug, Clone"),
          t("Debug, Clone, PartialEq"),
          t("Debug, Clone, PartialEq, Eq, Hash"),
          t("Debug, Clone, Serialize, Deserialize"),
        }) })),

        -- match with arms
        s("mat", fmt([[
match {} {{
	{} => {},
	_ => {},
}}
]], { i(1, "expr"), i(2, "pattern"), i(3, "{}"), i(4, "{}") })),

        -- Result propagation fn
        s("rfn", fmt([[
fn {}({}) -> Result<{}, {}> {{
	{}
}}
]], { i(1, "name"), i(2), i(3, "()"), i(4, "Box<dyn Error>"), i(5, "todo!()") })),

        -- async fn
        s("afn", fmt([[
async fn {}({}) -> {} {{
	{}
}}
]], { i(1, "name"), i(2), i(3, "()"), i(4, "todo!()") })),

        -- struct with fields
        s("st", fmt([[
#[derive(Debug, Clone)]
struct {} {{
	{}: {},
}}
]], { i(1, "Name"), i(2, "field"), i(3, "Type") })),
      })

      -- ── C / C++ snippets ───────────────────────────────
      luasnip.add_snippets("cpp", {
        -- class with constructor/destructor
        s("cls", fmt([[
class {} {{
public:
	{}();
	~{}();

private:
	{}
}};
]], { i(1, "MyClass"), rep(1), rep(1), i(2, "// members") })),

        -- range-based for
        s("forr", fmt([[
for (auto& {} : {}) {{
	{}
}}
]], { i(1, "elem"), i(2, "container"), i(3) })),

        -- lambda
        s("lam", fmt([[
[{}]({}) {} {{
	{}
}}
]], { c(1, { t("&"), t("="), t("") }), i(2), i(3, "-> void"), i(4) })),

        -- unique_ptr
        s("uniq", fmt([[
auto {} = std::make_unique<{}>({}); 
]], { i(1, "ptr"), i(2, "Type"), i(3) })),

        -- shared_ptr
        s("shar", fmt([[
auto {} = std::make_shared<{}>({}); 
]], { i(1, "ptr"), i(2, "Type"), i(3) })),

        -- namespace block
        s("ns", fmt([[
namespace {} {{

{}

}} // namespace {}
]], { i(1, "name"), i(2), rep(1) })),
      })

      -- Share C snippets for plain C too
      luasnip.add_snippets("c", {
        s("forr", fmt([[
for (size_t {} = 0; {} < {}; ++{}) {{
	{}
}}
]], { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) })),

        s("st", fmt([[
typedef struct {} {{
	{}
}} {};
]], { i(1, "Name"), i(2, "// fields"), rep(1) })),
      })

      -- ── CMake snippets ────────────────────────────────
      luasnip.add_snippets("cmake", {
        s("exe", fmt([[
add_executable({} {})
target_link_libraries({} PRIVATE {})
target_include_directories({} PRIVATE {})
]], { i(1, "target"), i(2, "main.cpp"), rep(1), i(3, "libs"), rep(1), i(4, "include") })),

        s("lib", fmt([[
add_library({} {})
target_include_directories({} PUBLIC {})
]], { i(1, "mylib"), i(2, "src/lib.cpp"), rep(1), i(3, "include") })),
      })

      -- ── nvim-cmp setup ─────────────────────────────────
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- Preselect first item so Enter immediately accepts it
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Esc>"]     = cmp.mapping.abort(),

          -- Confirm: Enter accepts, does NOT auto-select
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          -- Tab: next item or expand/jump snippet
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift+Tab: prev item or jump back in snippet
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Ctrl+J/K: move in popup without Tab
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),

          -- Scroll docs
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),

        sources = cmp.config.sources({
          -- 1. LSP (members, properties, methods — language-server-aware)
          { name = "nvim_lsp",               priority = 1000 },
          -- 2. Live signature help while filling function args
          { name = "nvim_lsp_signature_help",priority = 900 },
          -- 3. Snippets
          { name = "luasnip",                priority = 750 },
          -- 4. Words in open buffers
          { name = "buffer",                 priority = 500, keyword_length = 3 },
          -- 5. File paths
          { name = "path",                   priority = 250 },
        }),

        formatting = {
          -- Deduplicate entries shown from multiple sources
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode          = "symbol_text",
            maxwidth      = 50,
            ellipsis_char = "…",
            -- Show source tag so you know where each item comes from
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp               = "[LSP]",
                nvim_lsp_signature_help = "[Sig]",
                luasnip                = "[Snip]",
                buffer                 = "[Buf]",
                path                   = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },

        -- Sort: LSP items first, deprecated items last
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            -- Prefer items whose label starts with the typed prefix
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        -- Don't show completion in comments / strings for C/C++
        enabled = function()
          local ctx = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          end
          return not ctx.in_treesitter_capture("comment")
             and not ctx.in_syntax_group("Comment")
        end,
      })

      -- ── Cmdline completion ────────────────────────────
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })

      -- Search completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
    end,
  },

  -- ── LuaSnip standalone (snippet engine) ──────────────────
  {
    "L3MON4D3/LuaSnip",
    build        = "make install_jsregexp",   -- enables jsregexp transforms
    event        = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    keys = {
      -- Ctrl+L: jump forward in active snippet (works outside Tab)
      { "<C-l>", function() require("luasnip").jump(1)  end, mode = { "i", "s" }, desc = "Snippet jump forward" },
      -- Ctrl+H: jump back
      { "<C-b>", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, desc = "Snippet jump back" },
      -- Ctrl+E: cycle through choices in choice node
      {
        "<C-e>",
        function()
          if require("luasnip").choice_active() then
            require("luasnip").change_choice(1)
          end
        end,
        mode = { "i", "s" },
        desc = "Cycle snippet choice",
      },
    },
  },

  -- ── cmp-nvim-lsp-signature-help ──────────────────────────
  --  Shows function signature with current argument highlighted
  --  while you type inside the argument list — like VSCode's
  --  parameter hints pop-up.
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
}
