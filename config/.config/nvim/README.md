# Neovim Config — Complete Reference

> Leader key is **`Space`**. All `<leader>` mappings start with Space.

---

## Table of Contents

1. [Directory Structure](#1-directory-structure)
2. [All Keybindings](#2-all-keybindings)
3. [UI Customization](#3-ui-customization)
4. [Statusline](#4-statusline)
5. [Adding & Removing Plugins](#5-adding--removing-plugins)
6. [Lang Packs — Add / Remove / Create](#6-lang-packs--add--remove--create)
7. [Editor Behaviour](#7-editor-behaviour)
8. [Viewing Keybindings Inside Neovim](#8-viewing-keybindings-inside-neovim)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Directory Structure

```
~/.config/nvim/
├── init.lua                        ← entry point
└── lua/
    ├── core/
    │   ├── lazy.lua                ← plugin manager + lang pack list  ← edit to add/remove langs
    │   ├── keymaps.lua             ← all global keymaps
    │   ├── options.lua             ← editor options (indent, scroll, etc.)
    │   └── autocmds.lua            ← auto-commands (format on save, etc.)
    └── plugins/
        ├── ui.lua                  ← theme, statusline, bufferline, sidebar, dashboard
        ├── editor.lua              ← telescope, gitsigns, autopairs, terminal, folds
        ├── lsp.lua                 ← LSP infrastructure (mason, handlers, keymaps)
        ├── completion.lua          ← nvim-cmp + luasnip
        ├── treesitter.lua          ← treesitter base config
        ├── tools.lua               ← DAP core, lazygit, spectre, neotest
        └── langs/                  ← language packs (self-contained, plug-and-play)
            ├── go.lua
            ├── rust.lua
            ├── c.lua
            ├── python.lua
            ├── web.lua             ← JS/TS/HTML/CSS/JSON/YAML/TOML/Markdown
            ├── lua_lang.lua
            ├── kotlin.lua
            └── android.lua         ← Android extras (requires kotlin.lua)
```

**Rule of thumb — which file to edit:**

| What you want to change | File |
|-------------------------|------|
| Enable/disable a language | `core/lazy.lua` |
| Add a global keymap | `core/keymaps.lua` |
| Change indent size, line numbers, etc. | `core/options.lua` |
| Change the theme or statusline | `plugins/ui.lua` |
| Add a new generic plugin | `plugins/editor.lua` or `plugins/tools.lua` |
| Add a new language | Create `plugins/langs/<name>.lua`, add to `core/lazy.lua` |

---

## 2. All Keybindings

### General

| Key | Action |
|-----|--------|
| `jk` (insert mode) | Escape to normal mode |
| `Esc` | Clear search highlight |
| `Ctrl+S` | Save file |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |

### File Explorer (Sidebar)

| Key | Action |
|-----|--------|
| `Ctrl+B` | Toggle sidebar (NvimTree) |
| `<leader>e` | Focus sidebar |

### Tabs / Buffers

| Key | Action |
|-----|--------|
| `Ctrl+Tab` | Next buffer |
| `Ctrl+Shift+Tab` | Previous buffer |
| `<leader>x` | Close current buffer |
| `<leader>1` – `5` | Jump to buffer 1–5 |
| `Alt+1` – `9` | Jump to buffer 1–9 |

### Window Splits

| Key | Action |
|-----|--------|
| `<leader>\` | Vertical split |
| `<leader>-` | Horizontal split |
| `Ctrl+H` | Move to left split |
| `Ctrl+J` | Move to split below |
| `Ctrl+K` | Move to split above |
| `Ctrl+L` | Move to right split |

### Find (Telescope)

| Key | Action |
|-----|--------|
| `Ctrl+P` | Find files |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+F` | Fuzzy find in current buffer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in project) |
| `<leader>fb` | Open buffers list |
| `<leader>fr` | Recent files |
| `<leader>fs` | LSP document symbols |
| `<leader>ft` | Todo comments |
| `<leader>d` | Project diagnostics |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `gr` | References (Telescope) |
| `K` | Hover documentation |
| `Ctrl+K` | Signature help |
| `<leader>rn` or `F2` | Rename symbol |
| `<leader>ca` or `Ctrl+.` | Code action |
| `<leader>f` or `Shift+Alt+F` | Format file |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Editing

| Key | Action |
|-----|--------|
| `Alt+J` | Move line(s) down |
| `Alt+K` | Move line(s) up |
| `Tab` (visual) | Indent selection |
| `Shift+Tab` (visual) | Unindent selection |
| `Ctrl+/` | Toggle comment |
| `s` | Flash jump (2-char search) |
| `S` | Flash treesitter jump |
| `zR` | Open all folds |
| `zM` | Close all folds |

### Terminal

| Key | Action |
|-----|--------|
| `` Ctrl+` `` | Toggle terminal |
| `Esc` (in terminal) | Exit terminal mode |

### Debug (DAP)

| Key | Action |
|-----|--------|
| `F5` | Continue / Start |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

### Tests (Neotest)

| Key | Action |
|-----|--------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run all tests in file |
| `<leader>ts` | Toggle test summary |

### Diagnostics / Panels

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics panel (Trouble) |
| `<leader>xq` | Toggle quickfix (Trouble) |
| `<leader>sr` | Project-wide search & replace (Spectre) |
| `<leader>gg` | Open LazyGit |

### Git (gitsigns, per-buffer)

| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gu` | Undo staged hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff this |

### Language-Specific

**Go** (`<leader>g…`)

| Key | Action |
|-----|--------|
| `<leader>gt` | Run tests |
| `<leader>gT` | Run test under cursor |
| `<leader>gf` | Format |
| `<leader>gi` | Fix imports |
| `<leader>gI` | Add if-err block |
| `<leader>ga` | Alternate file (switch to/from test file) |

**Rust** (`<leader>r…`)

| Key | Action |
|-----|--------|
| `<leader>re` | Expand macro |
| `<leader>rr` | Runnables |
| `<leader>rt` | Testables |
| `<leader>rd` | Debuggables |

**Kotlin** (`<leader>k…`)

| Key | Action |
|-----|--------|
| `<leader>kr` | Compile & run (jar) |
| `<leader>ks` | Run as script |

**Android** (`<leader>a…`, requires kotlin.lua)

| Key | Action |
|-----|--------|
| `<leader>ab` | Gradle assembleDebug |
| `<leader>ai` | Gradle installDebug |
| `<leader>ar` | Gradle connectedDebugAndroidTest |
| `<leader>al` | ADB logcat |
| `<leader>ac` | ADB clear logs |
| `<leader>ad` | ADB list devices |

### Misc

| Key | Action |
|-----|--------|
| `<leader>L` | Open Lazy plugin manager |
| `<leader>M` | Open Mason installer |
| `<leader>h` | Check health |
| `q` | Close help/man/quickfix windows |

---

## 3. UI Customization

All visual config lives in **`lua/plugins/ui.lua`**.

### Change the colorscheme flavour

```lua
-- plugins/ui.lua → catppuccin opts
opts = {
  flavour = "mocha",  -- "latte" | "frappe" | "macchiato" | "mocha"
}
```

### Switch to a completely different theme

1. Replace the `catppuccin` plugin spec with your new theme plugin.
2. Change the `vim.cmd.colorscheme(...)` call in its `config` block.
3. Update lualine's `theme` option to match (or set it to `"auto"`).

```lua
-- Example: switching to tokyonight
{
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
},
-- Then in lualine opts:
options = { theme = "tokyonight" }
```

### Change the tab/buffer bar style

```lua
-- plugins/ui.lua → bufferline opts
options = {
  separator_style = "slant",   -- "slant" | "thick" | "thin" | "padded_slant"
  numbers         = "none",    -- "none"  | "ordinal" | "buffer_id"
}
```

### Change the sidebar width or position

```lua
-- plugins/ui.lua → nvim-tree opts
view = { width = 32, side = "left" },  -- side = "left" | "right"
```

### Change notification style / timeout

```lua
-- plugins/ui.lua → nvim-notify config
notify.setup({ stages = "fade_in_slide_out", timeout = 2500, max_width = 60 })
-- stages options: "fade" | "slide" | "fade_in_slide_out" | "static"
```

### Extend which-key groups

```lua
-- plugins/ui.lua → which-key opts.spec
spec = {
  { "<leader>f", group = "Find/Files" },
  { "<leader>l", group = "LSP" },
  { "<leader>g", group = "Git" },
  { "<leader>t", group = "Terminal" },
  { "<leader>d", group = "Debug" },   -- add more groups here
  { "g",         group = "Goto" },
  { "z",         group = "Fold" },
},
```

---

## 4. Statusline

The statusline is **lualine.nvim**, configured in `plugins/ui.lua`.

### Sections layout

```
| mode | branch · diff · diagnostics | filename | [lsp servers] encoding format | progress | location |
  (a)            (b)                    (c)              (x)                      (y)         (z)
```

### Change what each section shows

```lua
-- plugins/ui.lua → lualine opts.sections
sections = {
  lualine_a = { "mode" },
  lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
  lualine_c = { { "filename", path = 1 } },  -- path=0 filename only, path=1 relative, path=2 absolute
  lualine_x = { "encoding", "fileformat", "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
},
```

### Add active LSP servers to the statusline

Replace `lualine_x` with:

```lua
lualine_x = {
  {
    function()
      local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
      if #clients == 0 then return "󰚌 No LSP" end
      local names = {}
      for _, c in ipairs(clients) do table.insert(names, c.name) end
      return "󰒡 " .. table.concat(names, ", ")
    end,
    color = { fg = "#c6a0f6" },
  },
  "encoding",
  "fileformat",
  "filetype",
},
```

### Change the statusline theme

```lua
options = {
  theme = "catppuccin-mocha",  -- or "auto", "tokyonight", "gruvbox", etc.
}
```

---

## 5. Adding & Removing Plugins

### Add a generic plugin

Add a spec to **`plugins/editor.lua`** (for editing tools) or **`plugins/tools.lua`** (for dev tools):

```lua
-- Example: adding vim-illuminate (highlight word under cursor)
{
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  opts = { delay = 200 },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
},
```

Key lazy-loading triggers:

| Trigger | When it loads |
|---------|--------------|
| `event = "BufReadPost"` | After opening a file |
| `event = "InsertEnter"` | When entering insert mode |
| `event = "VeryLazy"` | After startup is complete |
| `cmd = "MyCommand"` | When that command is run |
| `keys = { "<leader>x" }` | When that key is pressed |
| `ft = { "go", "rust" }` | Only for those filetypes |
| `lazy = false` | Always load at startup |

### Remove a plugin

Comment out or delete its spec block. If it was `require`d elsewhere, remove those references too.

### Add a new keymap

Open **`core/keymaps.lua`** and add:

```lua
map("n", "<leader>xx", "<cmd>SomeCommand<CR>", opts)   -- normal mode
map("i", "<C-h>",      "<Left>",               opts)   -- insert mode
map("v", "<leader>s",  ":sort<CR>",            opts)   -- visual mode
map("n", "<leader>fn", function()                       -- Lua function
  require("some-plugin").do_thing()
end, { desc = "Do the thing" })
```

Mode codes: `"n"` normal · `"i"` insert · `"v"` visual · `"t"` terminal · `"x"` visual-only.

---

## 6. Lang Packs — Add / Remove / Create

### Enable or disable a language

Edit **`lua/core/lazy.lua`** — one line per pack:

```lua
{ import = "plugins.langs.go" },
{ import = "plugins.langs.rust" },
-- { import = "plugins.langs.android" },  ← comment out to disable
```

Nothing else needs to change.

### Available packs

| File | What it installs |
|------|-----------------|
| `go.lua` | gopls, gofumpt, goimports, dap-go, neotest-go, go.nvim |
| `rust.lua` | rustaceanvim (rust-analyzer), clippy, lldb DAP, neotest-rust |
| `c.lua` | clangd, clang-format, lldb DAP |
| `python.lua` | pyright, black, flake8 |
| `web.lua` | ts_ls, html, cssls, jsonls, taplo, bashls, prettier, markdown-preview |
| `lua_lang.lua` | lua_ls, stylua |
| `kotlin.lua` | kotlin_language_server, ktlint, kotlin-debug-adapter, neotest-kotlin |
| `android.lua` | Gradle + ADB keymaps, Android DAP config *(needs kotlin.lua)* |

### Create a new language pack

1. Create `lua/plugins/langs/zig.lua` using the template below.
2. Add `{ import = "plugins.langs.zig" }` to `core/lazy.lua`.
3. Done — no other file changes.

**Minimal template:**

```lua
-- lua/plugins/langs/zig.lua

return {
  -- 1. Tell mason-lspconfig to install the server
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zls" })
    end,
  },

  -- 2. Configure the LSP server
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.config("zls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("zls")
    end,
  },

  -- 3. Register a formatter/linter via none-ls (optional)
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "zig" },
    config = function()
      local nls = require("null-ls")
      nls.register({ nls.builtins.formatting.zigfmt })
    end,
  },

  -- 4. Tell mason-null-ls to install the formatter tool
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zigfmt" })
    end,
  },

  -- 5. Install the treesitter grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "zig" })
    end,
  },

  -- 6. Filetype-specific keymaps (optional)
  {
    "neovim/nvim-lspconfig",  -- any already-loaded plugin as anchor
    ft = { "zig" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "zig",
        group    = vim.api.nvim_create_augroup("ZigKeymaps", { clear = true }),
        callback = function()
          local map = function(l, r, d)
            vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
          end
          map("<leader>zr", "<cmd>!zig run %<CR>", "Zig: Run file")
          map("<leader>zt", "<cmd>!zig test %<CR>", "Zig: Test file")
        end,
      })
    end,
  },
}
```

**What each section can add:**

| Thing | How |
|-------|-----|
| LSP server | Extend `mason-lspconfig` `ensure_installed`, call `vim.lsp.config()` + `vim.lsp.enable()` |
| Formatter/linter | Add an `optional = true` none-ls spec, register with `nls.register()` |
| Mason tool | Extend `mason-null-ls` `ensure_installed` |
| DAP adapter | Depend on `nvim-dap`, configure adapter + launch config in `ft`-scoped `config` |
| Neotest adapter | Depend on `neotest` + adapter plugin, insert into `opts.adapters` |
| Treesitter grammar | Extend `nvim-treesitter` `ensure_installed` |
| Keymaps | `vim.api.nvim_create_autocmd("FileType", ...)` |

### Termux / Android notes

Comment out packs that need desktop binaries not available on Termux:

```lua
{ import = "plugins.langs.kotlin" },   -- works on Termux
-- { import = "plugins.langs.android" }, -- needs adb/gradlew
-- { import = "plugins.langs.rust" },    -- lldb-vscode may not exist
-- { import = "plugins.langs.c" },       -- same
```

Or guard inside a pack:

```lua
if vim.fn.executable("lldb-vscode") == 1 then
  dap.adapters.lldb = { ... }
end
```

---

## 7. Editor Behaviour

All options live in **`lua/core/options.lua`**.

| Option | Default | Effect |
|--------|---------|--------|
| `shiftwidth` / `tabstop` | `4` | Default indent size |
| `expandtab` | `true` | Spaces instead of tabs |
| `scrolloff` | `8` | Lines kept above/below cursor |
| `relativenumber` | `true` | Relative line numbers |
| `wrap` | `false` | Disable line wrapping |
| `pumheight` | `12` | Max items in completion popup |
| `updatetime` | `200` | Delay before CursorHold fires (ms) |
| `timeoutlen` | `300` | Which-key popup delay (ms) |

Per-language indent overrides are in **`lua/core/autocmds.lua`** — Go uses tabs/4, Lua/web uses spaces/2.

Auto-format on save is also in `autocmds.lua`:

```lua
-- autocmds.lua — add filetypes here to auto-format on save
pattern = { "*.go", "*.rs", "*.c", "*.cpp", "*.h", "*.lua" },
```

---

## 8. Viewing Keybindings Inside Neovim

**Press `Space` and wait** — which-key shows a popup of everything available under that prefix.

**Search all keybindings:**
```vim
:Telescope keymaps
```

**List mappings by mode:**
```vim
:nmap   " all normal mode mappings
:imap   " all insert mode mappings
:vmap   " all visual mode mappings
```

**Check what a specific key does:**
```vim
:map <C-b>
:map <leader>rn
```

---

## 9. Troubleshooting

| Command | What it checks |
|---------|---------------|
| `:checkhealth` | Full system health (LSP, providers, plugins) |
| `:Lazy` | Plugin status, update, profile startup time |
| `:Lazy profile` | Per-plugin startup timing breakdown |
| `:Mason` | LSP server / formatter install status |
| `:LspInfo` | Active LSP clients for the current buffer |
| `:TSUpdate` | Update all treesitter parsers |
| `:Telescope diagnostics` | All diagnostics across the project |

**Suppress optional provider warnings** — add to `core/options.lua`:

```lua
vim.g.loaded_node_provider  = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider  = 0
vim.g.loaded_ruby_provider  = 0
```

**Disable the startup update checker** — add to `core/lazy.lua` opts:

```lua
checker = { enabled = false },
-- Or check weekly instead:
-- checker = { enabled = true, notify = false, frequency = 3600 * 24 * 7 },
```
