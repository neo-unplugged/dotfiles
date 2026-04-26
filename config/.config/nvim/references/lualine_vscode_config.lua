-- ─────────────────────────────────────────────
--  plugins/ui.lua - Updated with VSCode statusline
-- ─────────────────────────────────────────────

return {
  -- ... other plugins ...

  -- ── Statusline with LSP info ──────────────────
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
        -- Left section
        lualine_a = { "mode" },
        
        -- Middle-left section (file info)
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
        
        -- Center section (filename)
        lualine_c = {
          { "filename", path = 1, file_status = true, symbols = { modified = " ●", readonly = " 🔒", unnamed = "[No Name]" } },
        },
        
        -- Middle-right section (LSP servers)
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
            cond = function()
              return vim.fn.strlen(vim.o.fileencoding) > 0
            end,
          },
          {
            "fileformat",
            fmt = string.upper,
            symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            color = { fg = "#8087a2" },
          },
        },
        
        -- Right section (position)
        lualine_y = {
          { "progress", fmt = function(str) return str .. "%" end, color = { fg = "#a6da95" } },
        },
        lualine_z = {
          { "location", color = { fg = "#f5bde6" } },
        },
      },
      
      -- Inactive window statusline
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      
      -- Tabline (shows open buffers like VSCode)
      tabline = {},
      extensions = { "nvim-tree", "trouble", "fzf", "quickfix" },
    },
  },

  -- ... rest of plugins ...
}
