# VSCode-Style Keybindings for Neovim

## Sidebar Toggle (File Explorer)

| Action | Keybind | Command |
|--------|---------|---------|
| Toggle Sidebar | `Ctrl+B` | `:NvimTreeToggle` |
| Focus Sidebar | `Ctrl+B` twice or `:NvimTreeFocus` | `:NvimTreeFocus` |

## Buffer/Tab Navigation

| Action | Keybind | Command |
|--------|---------|---------|
| Next Tab | `Ctrl+Tab` | `:BufferLineCycleNext` |
| Previous Tab | `Ctrl+Shift+Tab` | `:BufferLineCyclePrev` |
| Go to Tab 1 | `Alt+1` | `:BufferLineGoToBuffer 1` |
| Go to Tab 2 | `Alt+2` | `:BufferLineGoToBuffer 2` |
| Go to Tab 3 | `Alt+3` | `:BufferLineGoToBuffer 3` |
| ... | `Alt+9` | `:BufferLineGoToBuffer 9` |
| Close Buffer/Tab | `Ctrl+W` | `:Bdelete` |
| Close All Tabs | `:bufdo Bdelete` | — |

## Navigation (Like VSCode)

| Action | Keybind | VSCode Equivalent |
|--------|---------|------------------|
| Find Files | `Ctrl+P` | `Ctrl+P` |
| Find in Files | `Ctrl+Shift+F` | `Ctrl+Shift+F` |
| Quick Open | `Ctrl+P` | `Ctrl+P` |
| Command Palette | `Ctrl+Shift+P` | `Ctrl+Shift+P` |
| Go to Definition | `gd` | `F12` |
| Go to Line | `Ctrl+G` | `Ctrl+G` |
| Terminal Toggle | `Ctrl+~` or `Ctrl+`` ` | `Ctrl+~` |

## LSP Actions

| Action | Keybind | Description |
|--------|---------|-------------|
| Hover | `K` | Show docs on hover |
| Go to Definition | `gd` | Jump to definition |
| Go to Type | `gt` | Jump to type definition |
| References | `gr` | Show all references |
| Rename | `<leader>rn` or `F2` | Rename symbol |
| Code Action | `<leader>ca` or `Ctrl+.` | Quick fix / refactor |
| Format | `Shift+Alt+F` | Format document |
| Next Error | `]d` | Jump to next diagnostic |
| Prev Error | `[d` | Jump to previous diagnostic |

## Example Workflow (VSCode-style)

```
1. Open Neovim
2. Press Ctrl+P → Find file
3. Open file → tabs appear at top
4. Press Ctrl+B → Toggle sidebar off
5. Press Ctrl+Tab → Switch between open tabs
6. Press Ctrl+W → Close current tab
7. Press gd → Go to definition
8. Press Ctrl+B → Toggle sidebar back on
```

## Customization

If you want to change any keybinds, edit `plugins/ui.lua`:

### Change Tab Navigation
```lua
-- Instead of Ctrl+Tab, use Alt+J / Alt+K
map("n", "<A-j>",  "<cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
map("n", "<A-k>",  "<cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
```

### Change Sidebar Toggle
```lua
-- Instead of Ctrl+B, use Ctrl+E (like VSCode)
keys = { 
  { "<C-e>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle Sidebar" }
},
```

### Change Buffer Close
```lua
-- Instead of Ctrl+W, use Ctrl+Shift+Q
map("n", "<C-S-q>", "<cmd>Bdelete<CR>", { noremap = true, silent = true })
```

## Important Notes

- **Tabs show open buffers** (like VSCode) — each file you open gets a tab
- **Sidebar shows file tree** — click to open files or use `Ctrl+P` to search
- **Bufferline stays visible** — you can always see what files are open
- **Buffers are per-session** — closing Neovim removes them (use `:mks` to save session)

## Quick Tips

1. **Use Ctrl+P** — fastest way to find and open files (like VSCode)
2. **Use Ctrl+Tab** — switch between most recent buffers
3. **Use Ctrl+B** — toggle sidebar when you need more space
4. **Use Alt+1-9** — jump directly to a specific tab

---

**This setup mimics VSCode's layout:**
```
┌──────────────────────────────┐
│ Tab1  Tab2  Tab3  ✕ ✕       │
├──────────────────────────────┤
│ │                           │
│ │  File Editor Content      │
│ │                           │
│ │                           │
├─┴──────────────────────────┤
│ Status Line                 │
└─────────────────────────────┘
```
