# Upgrade Statusline to Show LSP Status (VSCode Style)

## What You'll Get

A bottom statusline like VSCode showing:

```
 NORMAL  main  ✓ 5  ✗ 2  │  main.go  │ 󰒡 gopls, pylsp  │ UTF-8 LF │ 50% │ 10:45
```

Breaking down:
- **NORMAL** = Current mode
- **main** = Git branch
- **✓ 5 ✗ 2** = Diff stats (added/modified)
- **main.go** = Current filename
- **󰒡 gopls, pylsp** = **ACTIVE LANGUAGE SERVERS** ← This is the new part!
- **UTF-8 LF** = Encoding & line ending
- **50%** = Progress through file
- **10:45** = Current line:column

---

## How to Update Your Config

### Step 1: Update `plugins/ui.lua`

Find the lualine section and replace the entire opts with this:

```lua
{
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme                = "catppuccin-mocha",
      globalstatus         = true,
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      
      lualine_b = {
        { "branch", icon = "", color = { fg = "#a6da95" } },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true,
        },
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          diagnostics_color = {
            error = { fg = "#f38181" },
            warn  = { fg = "#eed49f" },
            info  = { fg = "#8087a2" },
            hint  = { fg = "#91d7e3" },
          },
        },
      },
      
      lualine_c = {
        { "filename", path = 1, file_status = true, symbols = { modified = " ●", readonly = " 🔒", unnamed = "[No Name]" } },
      },
      
      -- THIS IS THE NEW PART - Shows active LSP servers
      lualine_x = {
        {
          function()
            local buf_clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
            if #buf_clients == 0 then
              return "󰚌 No LSP"
            end
            local client_names = {}
            for _, client in ipairs(buf_clients) do
              table.insert(client_names, client.name)
            end
            return "󰒡 " .. table.concat(client_names, ", ")
          end,
          color = { fg = "#c6a0f6" },
          cond = function()
            return vim.fn.mode() ~= "c"
          end,
        },
        {
          "encoding",
          fmt = string.upper,
          color = { fg = "#8087a2" },
        },
        {
          "fileformat",
          fmt = string.upper,
          symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
          color = { fg = "#8087a2" },
        },
      },
      
      lualine_y = {
        { "progress", fmt = function(str) return str .. "%" end, color = { fg = "#a6da95" } },
      },
      lualine_z = {
        { "location", color = { fg = "#f5bde6" } },
      },
    },
    
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    
    tabline = {},
    extensions = { "nvim-tree", "trouble", "fzf", "quickfix" },
  },
}
```

---

## What's New

### Key Addition: LSP Server Display

```lua
{
  function()
    local buf_clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #buf_clients == 0 then
      return "󰚌 No LSP"
    end
    local client_names = {}
    for _, client in ipairs(buf_clients) do
      table.insert(client_names, client.name)
    end
    return "󰒡 " .. table.concat(client_names, ", ")
  end,
  color = { fg = "#c6a0f6" },  -- Purple color
}
```

This function:
1. Gets all active LSP clients for the current buffer
2. Shows "󰚌 No LSP" if none are active
3. Shows "󰒡 gopls, pylsp" if multiple are active
4. Displays in purple (matches Catppuccin mocha)

---

## Customization

### Change LSP Display Color

```lua
color = { fg = "#c6a0f6" },  -- Change this to any color

-- Options:
-- Red:      { fg = "#f38181" }
-- Green:    { fg = "#a6da95" }
-- Blue:     { fg = "#8aadf4" }
-- Yellow:   { fg = "#eed49f" }
-- Cyan:     { fg = "#91d7e3" }
-- Purple:   { fg = "#c6a0f6" }
```

### Change LSP Icon

```lua
return "󰒡 " .. table.concat(client_names, ", ")
       ↑
       Change this icon to any nerd font icon

-- Options:
-- "󰒡" = Modern LSP icon (default)
-- "" = Code brackets
-- "󰈙" = File code
-- "🔧" = Wrench
-- "⚙️" = Gear
```

### Show Only First Server Name

If you have many LSP servers and want simpler display:

```lua
return "󰒡 " .. (buf_clients[1] and buf_clients[1].name or "No LSP")
```

### Show LSP Count Instead of Names

```lua
return "󰒡 " .. #buf_clients .. " server" .. (#buf_clients > 1 and "s" or "")
-- Shows: "󰒡 2 servers" or "󰒡 1 server"
```

---

## Testing

After updating, restart Neovim:

```bash
nvim
```

Then:
1. Open a Python file → Should show "󰒡 pyright" in statusline
2. Open a Go file → Should show "󰒡 gopls" in statusline
3. Open a Lua file → Should show "󰒡 lua_ls" in statusline
4. Open a random .txt file → Should show "󰚌 No LSP"

---

## Before vs After

### Before
```
 NORMAL  main  ✓ 5  ✗ 2  │  main.go  │ utf-8  unix  │ 50%  │ 10:45
```

### After
```
 NORMAL  main  ✓ 5  ✗ 2  │  main.go  │ 󰒡 gopls  │ UTF-8  LF  │ 50%  │ 10:45
```

---

## Troubleshooting

**LSP not showing in statusline?**
1. Make sure LSP is actually active: `:LspInfo`
2. Check that you're in a file type that has LSP configured
3. Restart Neovim after config change

**Want even more info?**
You can add:
- Formatting status (prettier, black running)
- Linting status (flake8 results)
- Test status (tests passing/failing)
- Git status details

Just ask if you want advanced statusline features!
