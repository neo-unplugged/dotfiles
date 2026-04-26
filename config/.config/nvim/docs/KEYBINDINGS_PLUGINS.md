# How to View Keybindings in Neovim

## Option 1: Which-Key (Already Installed! ✅)

You already have **which-key.nvim** in your config!

### How to use:
Press your leader key (`Space`) and wait 1 second → menu appears showing all available keybindings

```
Press: Space
Wait: 1 second
Shows: All <leader> keybindings
```

Then:
- **`f`** → Shows all Find/Files commands
- **`l`** → Shows all LSP commands  
- **`g`** → Shows all Git commands
- **`t`** → Shows all Terminal commands

### In Your Config
It's already set up in `plugins/ui.lua`:
```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts  = {
    preset = "modern",
    spec   = {
      { "<leader>f",  group = "Find/Files" },
      { "<leader>l",  group = "LSP" },
      { "<leader>g",  group = "Git" },
      { "<leader>t",  group = "Terminal" },
    },
  },
}
```

---

## Option 2: Telescope Keymaps Extension

View ALL keybindings with Telescope:

```vim
:Telescope keymaps
```

This shows:
- All keybindings in your config
- What each one does
- Which mode it's in (normal, insert, etc)
- Searchable/filterable

---

## Option 3: Native Neovim Commands

### View all keybindings:
```vim
:nmap              " Normal mode mappings
:imap              " Insert mode mappings
:vmap              " Visual mode mappings
```

### View specific keybinding:
```vim
:map <C-b>         " Shows what Ctrl+B does
:map <leader>rn    " Shows what Space+rn does
```

---

## Option 4: Built-in :help

```vim
:help key-notation   " Learn keybinding notation
:help mapping        " Learn about mappings
```

---

## Recommended Workflow

1. **Quick lookup** → Press `Space` (which-key shows everything)
2. **Search keybindings** → `:Telescope keymaps` 
3. **View all LSP keybindings** → Press `Space` then `l`
4. **View all Git keybindings** → Press `Space` then `g`

---

## Adding to Your Config

If you want a dedicated keybindings plugin, add this to `plugins/ui.lua`:

```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts  = {
    preset = "modern",
    icons  = { mappings = true },
    spec   = {
      { "<leader>f",  group = "󰈞 Find/Files" },
      { "<leader>l",  group = "󰒡 LSP" },
      { "<leader>g",  group = " Git" },
      { "<leader>t",  group = " Terminal" },
      { "<leader>d",  group = "🐛 Debug" },
      { "<leader>x",  group = "⚡ Trouble" },
      { "<leader>s",  group = "🔍 Search" },
      { "g",          group = "Goto" },
      { "z",          group = "Fold" },
      { "[",          group = "Prev" },
      { "]",          group = "Next" },
    },
  },
}
```

---

## Best Plugins for Keybindings

| Plugin | Purpose | How to Use |
|--------|---------|-----------|
| **which-key.nvim** ✅ (You have this!) | Pop-up menu of keybindings | Press `Space` |
| **Telescope keymaps** | Searchable list of all keybindings | `:Telescope keymaps` |
| **Hydra.nvim** | Organize related keybindings into groups | Advanced, optional |
| **Legendary.nvim** | Command/keybinding palette (VSCode Cmd+P style) | `:Legendary` |

---

## TL;DR

**To see all your keybindings:**
1. Press **`Space`** → which-key menu appears
2. Or run **`:Telescope keymaps`** → searchable list
3. Or check the **KEYBINDINGS_SUMMARY.md** file

That's it! Which-key is the easiest since you already have it installed.
