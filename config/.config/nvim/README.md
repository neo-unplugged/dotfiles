# 🚀 VSCode-like Neovim Config

Modular, feature-rich Neovim setup built with **lazy.nvim**.
Supports Go · C/C++ · Rust · Lua · Python · Web out-of-the-box.

---

## 📁 Directory Structure

```
~/.config/nvim/
├── init.lua                  ← entry point
└── lua/
    ├── core/
    │   ├── options.lua       ← editor settings
    │   ├── keymaps.lua       ← all keybindings
    │   ├── autocmds.lua      ← automatic behaviours
    │   └── lazy.lua          ← plugin manager bootstrap
    └── plugins/
        ├── ui.lua            ← theme, statusline, bufferline, sidebar
        ├── editor.lua        ← telescope, git, terminal, pairs…
        ├── lsp.lua           ← Mason + LSP + null-ls formatters
        ├── completion.lua    ← nvim-cmp + LuaSnip
        ├── treesitter.lua    ← syntax, text-objects, context
        └── tools.lua         ← DAP debugger, Go extras, test runner
```

---

## ⚡ Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Copy this folder
cp -r /path/to/this/nvim ~/.config/nvim

# Launch Neovim — lazy.nvim bootstraps itself and installs everything
nvim
```

On first launch, Lazy installs all plugins, then Mason auto-installs
all language servers and formatters. Expect ~2 minutes on first boot.

---

## 🎨 Theme

**Catppuccin Mocha** — a warm dark palette that matches VSCode Dark+.
Change `flavour` in `plugins/ui.lua` to `latte` / `frappe` / `macchiato`.

---

## ⌨️  Key Bindings (VSCode-like)

### General
| Key | Action |
|-----|--------|
| `Ctrl+S` | Save file |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |
| `Ctrl+/` | Toggle comment |
| `Space` | Leader key |

### Sidebar & Files
| Key | Action |
|-----|--------|
| `Ctrl+B` | Toggle file explorer |
| `Space e` | Focus file explorer |
| `Ctrl+P` | Fuzzy find files |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+F` | Search in current buffer |
| `Space fg` | Live grep (project-wide) |

### Tabs / Buffers
| Key | Action |
|-----|--------|
| `Ctrl+Tab` | Next buffer/tab |
| `Ctrl+Shift+Tab` | Previous buffer/tab |
| `Ctrl+W` | Close current buffer |
| `Space 1–5` | Jump to buffer 1–5 |

### Windows / Splits
| Key | Action |
|-----|--------|
| `Ctrl+H/J/K/L` | Move between splits |
| `Space \` | Vertical split |
| `Space -` | Horizontal split |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `K` | Hover documentation |
| `F2` | Rename symbol |
| `Ctrl+.` | Code action |
| `Shift+Alt+F` | Format document |
| `[d` / `]d` | Previous / next diagnostic |
| `Space d` | Diagnostics panel (Telescope) |

### Debugger (DAP)
| Key | Action |
|-----|--------|
| `F5` | Start / Continue |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `Space db` | Toggle breakpoint |
| `Space du` | Toggle DAP UI |

### Terminal
| Key | Action |
|-----|--------|
| `` Ctrl+` `` | Toggle terminal |
| `Esc` | Exit terminal mode |

### Navigation
| Key | Action |
|-----|--------|
| `s` + 2 chars | Hop to any location |
| `S` | Hop to any word |
| `Alt+J/K` | Move line(s) up/down |
| `Tab` / `Shift+Tab` (visual) | Indent / unindent |

### Go-specific
| Key | Action |
|-----|--------|
| `Space gt` | Run tests |
| `Space gT` | Run test under cursor |
| `Space gi` | Fix imports |
| `Space gI` | Add if-err block |
| `Space ga` | Alternate (switch to test file) |

### Rust-specific
| Key | Action |
|-----|--------|
| `Space re` | Expand macro |
| `Space rr` | Runnables |
| `Space rt` | Testables |
| `Space rd` | Debuggables |

---

## 🔧 Language Servers Installed (via Mason)

| Language | Server | Formatter |
|----------|--------|-----------|
| Go | `gopls` | `gofumpt`, `goimports` |
| C/C++ | `clangd` | `clang-format` |
| Rust | `rust-analyzer` (rustaceanvim) | built-in |
| Lua | `lua_ls` | `stylua` |
| Python | `pyright` | `black` |
| JS/TS | `tsserver` | `prettier` |
| HTML/CSS | `html`, `cssls` | `prettier` |
| JSON | `jsonls` | `prettier` |
| Bash | `bashls` | `shfmt` |
| TOML | `taplo` | — |

---

## 📦 Key Plugins

| Category | Plugin |
|----------|--------|
| Plugin Manager | lazy.nvim |
| Theme | catppuccin/nvim |
| Statusline | lualine.nvim |
| Tabs | bufferline.nvim |
| File Explorer | nvim-tree |
| Fuzzy Finder | telescope.nvim |
| LSP | nvim-lspconfig + mason |
| Completion | nvim-cmp + LuaSnip |
| Syntax | nvim-treesitter |
| Formatter/Linter | none-ls (null-ls fork) |
| Debugger | nvim-dap + nvim-dap-ui |
| Go extras | go.nvim |
| Rust extras | rustaceanvim |
| Test runner | neotest |
| Git | gitsigns + lazygit |
| Terminal | toggleterm |
| UI polish | noice.nvim + nvim-notify |
| Folding | nvim-ufo |

---

## 🛠 Requirements

```bash
# Neovim >= 0.10
brew install neovim          # macOS
sudo apt install neovim      # Ubuntu/Debian

# Build tools (for telescope-fzf-native, treesitter)
sudo apt install build-essential

# Language toolchains
# Go:   https://go.dev/dl/
# Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# C++:  sudo apt install clang lldb

# Node.js (for tsserver, markdown-preview)
# https://nodejs.org

# Optional: ripgrep for Telescope live_grep
sudo apt install ripgrep fd-find
```

---

## 💡 Tips

- Run `:Lazy` to see/update plugins
- Run `:Mason` to install/update language servers
- Run `:checkhealth` to diagnose issues
- Run `:TSUpdate` to update Treesitter parsers
- Edit `core/options.lua` to tweak tab width, scroll offset, etc.
- Add more language servers by appending to `ensure_installed` in `plugins/lsp.lua`
