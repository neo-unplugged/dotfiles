# Scalable Neovim Config Structure

## Current Structure (What You Have)

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua      (editor settings)
│   │   ├── keymaps.lua      (keybindings)
│   │   ├── autocmds.lua     (auto commands)
│   │   └── lazy.lua         (plugin manager)
│   └── plugins/
│       ├── ui.lua           (UI plugins)
│       ├── editor.lua       (editor enhancements)
│       ├── lsp.lua          (language servers)
│       ├── completion.lua   (autocompletion)
│       ├── treesitter.lua   (syntax parsing)
│       └── tools.lua        (utilities)
└── docs/
    ├── OPTIMIZATION_GUIDE.md
    ├── KEYBINDINGS_SUMMARY.md
    └── ...
```

## Recommended Scalable Structure

```
~/.config/nvim/
├── init.lua                  # Main entry point (minimal)
├── lua/
│   ├── config/              # ← NEW: Core configuration
│   │   ├── init.lua         # Load all configs
│   │   ├── options.lua      # Editor settings
│   │   ├── keymaps.lua      # Global keybindings
│   │   ├── autocmds.lua     # Global auto commands
│   │   └── lazy.lua         # Lazy.nvim setup
│   │
│   ├── plugins/             # Plugin specifications
│   │   ├── init.lua         # ← NEW: Plugin loader
│   │   ├── ui/              # ← NEW: Organized by category
│   │   │   ├── init.lua
│   │   │   ├── colorscheme.lua
│   │   │   ├── statusline.lua
│   │   │   ├── bufferline.lua
│   │   │   └── notifications.lua
│   │   │
│   │   ├── editor/
│   │   │   ├── init.lua
│   │   │   ├── telescope.lua
│   │   │   ├── gitsigns.lua
│   │   │   ├── comments.lua
│   │   │   └── ...
│   │   │
│   │   ├── lsp/
│   │   │   ├── init.lua
│   │   │   ├── mason.lua
│   │   │   ├── lspconfig.lua
│   │   │   ├── none-ls.lua
│   │   │   └── fidget.lua
│   │   │
│   │   ├── completion/
│   │   │   ├── init.lua
│   │   │   └── nvim-cmp.lua
│   │   │
│   │   ├── treesitter/
│   │   │   ├── init.lua
│   │   │   └── nvim-treesitter.lua
│   │   │
│   │   └── tools/
│   │       ├── init.lua
│   │       ├── dap.lua
│   │       ├── go.lua
│   │       ├── git.lua
│   │       └── testing.lua
│   │
│   ├── utils/               # ← NEW: Shared utilities
│   │   ├── init.lua
│   │   ├── helpers.lua
│   │   ├── colors.lua       # Color definitions
│   │   └── keymaps.lua      # Keymap helper functions
│   │
│   └── autocmds/            # ← NEW: Organized auto commands
│       ├── init.lua
│       ├── formatting.lua
│       ├── filetypes.lua
│       └── lsp.lua
│
├── docs/                    # Documentation
│   ├── README.md
│   ├── OPTIMIZATION_GUIDE.md
│   ├── KEYBINDINGS_SUMMARY.md
│   ├── STATUSLINE_LSP_GUIDE.md
│   └── VSCODE_KEYBINDINGS.md
│
└── after/                   # ← NEW: Filetype-specific configs
    ├── ftplugin/
    │   ├── go.lua
    │   ├── rust.lua
    │   ├── python.lua
    │   └── lua.lua
    │
    └── syntax/
        └── custom.lua
```

---

## Migration Plan (Step by Step)

### Phase 1: Reorganize Core Config

**Step 1.1:** Create new structure
```bash
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/utils
mkdir -p ~/.config/nvim/lua/autocmds
mkdir -p ~/.config/nvim/after/ftplugin
mkdir -p ~/.config/nvim/docs
```

**Step 1.2:** Move existing files
```bash
# Core config
mv ~/.config/nvim/lua/core/* ~/.config/nvim/lua/config/
rm -rf ~/.config/nvim/lua/core/
```

**Step 1.3:** Create `config/init.lua`
```lua
-- ~/.config/nvim/lua/config/init.lua
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
```

### Phase 2: Reorganize Plugins

**Step 2.1:** Create plugin category folders
```bash
mkdir -p ~/.config/nvim/lua/plugins/{ui,editor,lsp,completion,treesitter,tools}
```

**Step 2.2:** Move plugins to categories

**UI plugins:** `plugins/ui/`
```bash
# Move colorscheme stuff
mv ~/.config/nvim/lua/plugins/ui.lua ~/.config/nvim/lua/plugins/ui/colorscheme.lua

# Split into smaller files
# ui/init.lua → imports all UI plugins
# ui/statusline.lua → lualine
# ui/bufferline.lua → bufferline
# ui/notifications.lua → nvim-notify, noice
# ui/dashboard.lua → alpha-nvim
# etc...
```

**LSP plugins:** `plugins/lsp/`
```bash
mkdir -p ~/.config/nvim/lua/plugins/lsp
# Create:
# lsp/init.lua
# lsp/mason.lua
# lsp/lspconfig.lua
# lsp/none-ls.lua
# lsp/fidget.lua
```

**Step 2.3:** Create `plugins/init.lua` loader
```lua
-- ~/.config/nvim/lua/plugins/init.lua
return {
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.treesitter" },
  { import = "plugins.tools" },
}
```

Then update `config/lazy.lua`:
```lua
require("lazy").setup(require("plugins"), {
  -- ... rest of config
})
```

### Phase 3: Add Utilities

**Step 3.1:** Create `utils/helpers.lua`
```lua
-- ~/.config/nvim/lua/utils/helpers.lua

local M = {}

-- Helper function for keymaps
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Helper for autocmds
function M.autocmd(event, opts)
  local augroup = vim.api.nvim_create_augroup(opts.group, { clear = true })
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = augroup }, opts))
end

return M
```

**Step 3.2:** Create `utils/colors.lua`
```lua
-- ~/.config/nvim/lua/utils/colors.lua
return {
  error   = "#f38181",
  warn    = "#eed49f",
  info    = "#8087a2",
  hint    = "#91d7e3",
  ok      = "#a6da95",
  purple  = "#c6a0f6",
  blue    = "#8aadf4",
}
```

---

## Benefits of This Structure

✅ **Scalability** - Easy to add new plugin categories
✅ **Maintainability** - Each plugin in its own file
✅ **Organization** - Clear separation of concerns
✅ **Reusability** - Utils can be shared across config
✅ **Readability** - Easier to find what you need
✅ **Modularity** - Easy to disable/enable plugin categories
✅ **Collaboration** - If sharing config, easier for others to understand

---

## Example: Adding New Feature

**Before (monolithic):**
```bash
# Edit one huge file
nvim ~/.config/nvim/lua/plugins/tools.lua  # Add 100 lines
```

**After (modular):**
```bash
# Create new focused file
nvim ~/.config/nvim/lua/plugins/tools/new-feature.lua  # Add 30 lines
# Update tools/init.lua to import it
```

---

## Example: File Contents

### `plugins/ui/init.lua`
```lua
-- ~/.config/nvim/lua/plugins/ui/init.lua
return {
  { import = "plugins.ui.colorscheme" },
  { import = "plugins.ui.statusline" },
  { import = "plugins.ui.bufferline" },
  { import = "plugins.ui.notifications" },
  { import = "plugins.ui.dashboard" },
  -- ... more UI plugins
}
```

### `plugins/ui/statusline.lua`
```lua
-- ~/.config/nvim/lua/plugins/ui/statusline.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Your lualine config here
    },
  },
}
```

### `plugins/ui/colorscheme.lua`
```lua
-- ~/.config/nvim/lua/plugins/ui/colorscheme.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = { ... },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
```

---

## Minimal Effort Migration

If you don't want to reorganize everything, just do this **minimum**:

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/          ← Rename from 'core'
│   │   ├── init.lua
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocmds.lua
│   │   └── lazy.lua
│   │
│   ├── plugins/         ← Keep as-is (can refactor later)
│   │   ├── ui.lua
│   │   ├── editor.lua
│   │   ├── lsp.lua
│   │   ├── completion.lua
│   │   ├── treesitter.lua
│   │   └── tools.lua
│   │
│   └── utils/           ← NEW: Add helpers if needed
│       └── helpers.lua
│
└── docs/
    └── ...
```

This gives you 80% of the benefits with 20% of the effort!

---

## My Recommendation

1. **Start with minimal migration** (just rename `core` → `config`)
2. **Keep plugins as-is** for now (works fine with 6 files)
3. **When adding new plugins**, create separate files under `plugins/`
4. **Gradually refactor** as you add more features

The current structure is actually pretty good! Only refactor when it becomes unwieldy (20+ plugins, complex keymaps, etc.)
