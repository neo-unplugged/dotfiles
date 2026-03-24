-- ============================================================
--  plugins/dap.lua — Debug Adapter Protocol (VSCode F5 style)
-- ============================================================

return {

  -- ── Core DAP ──────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end, desc = "Conditional Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end,         desc = "Open REPL" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")

      -- ── DAP UI auto open/close ───────────────────────────
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      -- ── Signs ────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint",          { text = "🔴", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DiagnosticWarn"  })
      vim.fn.sign_define("DapStopped",             { text = "▶",  texthl = "DiagnosticInfo", linehl = "DapStoppedLine" })

      -- ── Go (delve) ───────────────────────────────────────
      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = { command = "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
      }
      dap.configurations.go = {
        { type = "go", name = "Debug",            request = "launch", program = "${file}" },
        { type = "go", name = "Debug Package",    request = "launch", program = "${fileDirname}" },
        { type = "go", name = "Debug Test",       request = "launch", mode = "test", program = "${file}" },
        { type = "go", name = "Attach (remote)",  request = "attach", mode = "remote",
          host = "127.0.0.1", port = "38697" },
      }

      -- ── C / C++ / Rust (codelldb) ────────────────────────
      local codelldb_path = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = { command = codelldb_path, args = { "--port", "${port}" } },
      }
      for _, ft in ipairs({ "c", "cpp", "rust" }) do
        dap.configurations[ft] = {
          {
            type    = "codelldb",
            request = "launch",
            name    = "Launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd        = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
      end

      -- ── Python (debugpy) ─────────────────────────────────
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          cb({ type = "server", port = assert(port, "`connect.port` is required") })
        else
          cb({
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
            args = { "-m", "debugpy.adapter" },
          })
        end
      end
      dap.configurations.python = {
        {
          type    = "python",
          request = "launch",
          name    = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = vim.env.VIRTUAL_ENV
            if venv then return venv .. "/bin/python" end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end,
        },
      }
    end,
  },

  -- ── DAP UI ───────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    opts = {
      icons    = { expanded = "", collapsed = "", current_frame = "" },
      layouts  = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size     = 40,
          position = "left",
        },
        {
          elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
          size     = 10,
          position = "bottom",
        },
      },
    },
  },

  -- ── Virtual text (shows variable values inline) ───────────
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = { virt_text_pos = "eol" },
  },

  -- ── Go extras (test runner, coverage) ────────────────────
  {
    "leoluz/nvim-dap-go",
    ft           = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts         = { delve = { path = "dlv" } },
  },
}
