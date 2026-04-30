-- ─────────────────────────────────────────────
--  plugins/tools.lua  –  DAP, Git UI, extras
-- ─────────────────────────────────────────────

return {
	-- ── DAP (Debug Adapter Protocol) ─────────────
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Conditional Breakpoint",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
		},
		dependencies = {
			-- UI
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			"theHamsta/nvim-dap-virtual-text",
			-- Go adapter
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- UI toggle
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

			-- ── Go debugger (delve) ───────────────────
			require("dap-go").setup()

			-- ── C/C++ / Rust debugger (lldb) ─────────
			dap.adapters.lldb = {
				type = "executable",
				command = "/usr/bin/lldb-vscode", -- adjust to your lldb path
				name = "lldb",
			}
			for _, lang in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[lang] = {
					{
						name = "Launch",
						type = "lldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = {},
					},
				}
			end

			-- ── ADD HERE: Android / Kotlin debugger ──
			dap.adapters.kotlin = {
				type = "executable",
				command = "kotlin-debug-adapter",
				options = { auto_continue_if_many_stopped = false },
			}
			dap.configurations.kotlin = {
				{
					type = "kotlin",
					request = "launch",
					name = "Android Debug",
					projectRoot = "${workspaceFolder}",
					mainClass = function()
						return vim.fn.input("Main class: ", "com.example.MainActivityKt")
					end,
				},
			}

			-- ── ADD HERE: Kotlin FileType keymaps ─────
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "kotlin",
				callback = function()
					local map = function(l, r, d)
						vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
					end
					map("<leader>ab", "<cmd>!./gradlew assembleDebug<CR>", "Android Build")
					map("<leader>ai", "<cmd>!./gradlew installDebug<CR>", "Android Install")
					map("<leader>al", "<cmd>!adb logcat<CR>", "ADB Logcat")
					map("<leader>ac", "<cmd>!adb logcat -c<CR>", "ADB Clear Logs")
				end,
			})
		end,
	},

	-- ── Go extras (gotest, gorename, gotools UI) ─
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
		build = ':lua require("go.install").update_all_sync()',
		config = function()
			require("go").setup({
				lsp_inlay_hints = { enable = true },
				dap_debug = true,
				luasnip = true,
			})
			-- Extra keymaps for Go (only in go buffers)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					local map = function(l, r, d)
						vim.keymap.set("n", l, r, { buffer = true, silent = true, desc = d })
					end
					map("<leader>gt", "<cmd>GoTest<CR>", "Go Test")
					map("<leader>gT", "<cmd>GoTestFunc<CR>", "Go Test Function")
					map("<leader>gf", "<cmd>GoFmt<CR>", "Go Format")
					map("<leader>gi", "<cmd>GoImport<CR>", "Go Import")
					map("<leader>gI", "<cmd>GoIfErr<CR>", "Go Add If Err")
					map("<leader>ga", "<cmd>GoAlt<CR>", "Go Alternate (test)")

					-- ── ADD: standalone Kotlin compile & run ──
					map("<leader>kr", function()
						local file = vim.fn.expand("%")
						local jar = vim.fn.expand("%:r") .. ".jar"
						vim.cmd(string.format("!kotlinc %s -include-runtime -d %s && java -jar %s", file, jar, jar))
					end, "Kotlin Run")

					map("<leader>ks", function()
						local file = vim.fn.expand("%")
						vim.cmd(string.format("!kotlinc-jvm -script %s", file))
					end, "Kotlin Script Run")
				end,
			})
		end,
	},

	-- ── Git UI (Lazygit) ─────────────────────────
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
	},

	-- ── Spectre (project-wide find & replace) ────
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		keys = {
			{
				"<leader>sr",
				function()
					require("spectre").open()
				end,
				desc = "Search & Replace",
			},
		},
		opts = {},
	},

	-- ── Test runner ───────────────────────────────
	{
		"nvim-neotest/neotest",
		keys = {
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run file tests",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Test summary",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/nvim-nio",
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
			"codymikol/neotest-kotlin",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({ experimental = { test_table = true } }),
					require("neotest-rust"),
					require("neotest-kotlin"),
				},
			})
		end,
	},

	-- ── Kotlin syntax (filetype detection) ───────
	{
		"udalov/kotlin-vim",
		ft = { "kotlin" },
	},
}
