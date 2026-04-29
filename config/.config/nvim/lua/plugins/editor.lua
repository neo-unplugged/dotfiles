-- ─────────────────────────────────────────────
--  plugins/editor.lua  –  Editor enhancements
-- ─────────────────────────────────────────────

return {
	-- ── Telescope (fuzzy finder) ──────────────────
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local ts = require("telescope")
			local actions = require("telescope.actions")
			ts.setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = " ",
					path_display = { "smart" },
					layout_config = { horizontal = { preview_width = 0.55 } },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<Esc>"] = actions.close,
							["<C-u>"] = false,
						},
					},
				},
				extensions = {
					fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			ts.load_extension("fzf")
			ts.load_extension("ui-select")
		end,
	},

	-- ── Git signs in the gutter ───────────────────
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			on_attach = function(buf)
				local gs = package.loaded.gitsigns
				local map = function(m, l, r)
					vim.keymap.set(m, l, r, { buffer = buf, silent = true })
				end
				map("n", "]h", gs.next_hunk)
				map("n", "[h", gs.prev_hunk)
				map("n", "<leader>gs", gs.stage_hunk)
				map("n", "<leader>gu", gs.undo_stage_hunk)
				map("n", "<leader>gp", gs.preview_hunk)
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end)
				map("n", "<leader>gd", gs.diffthis)
			end,
		},
	},

	-- ── Comments ──────────────────────────────────
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- ── Auto pairs ────────────────────────────────
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local ap = require("nvim-autopairs")
			local cmp = require("cmp")
			ap.setup({ check_ts = true })
			-- integrate with cmp
			local cmp_ap = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
		end,
	},

	-- ── Surround ──────────────────────────────────
	{
		"kylechui/nvim-surround",
		event = "BufReadPost",
		version = "*",
		opts = {},
	},

	-- ── Multiple cursors / visual multi ───────────
	{ "mg979/vim-visual-multi", event = "BufReadPost" },

	-- ── Terminal ──────────────────────────────────
	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		keys = { "<C-`>" },
		opts = {
			size = 18,
			open_mapping = [[<C-`>]],
			direction = "horizontal",
			shell = vim.o.shell,
			highlights = { NormalFloat = { link = "NormalFloat" } },
		},
	},

	-- ── Hop (quick navigation) ────────────────────
	{
		"phaazon/hop.nvim",
		branch = "v2",
		event = "BufReadPost",
		config = function()
			local hop = require("hop")
			hop.setup()
			vim.keymap.set("n", "s", "<cmd>HopChar2<CR>")
			vim.keymap.set("n", "S", "<cmd>HopWord<CR>")
		end,
	},

	-- ── Buffer delete (keeps window layout) ───────
	{ "famiu/bufdelete.nvim", lazy = true },

	-- ── Folds (pretty code folding) ───────────────
	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
		config = function(_, opts)
			require("ufo").setup(opts)
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
	},

	-- ── Colorizer ─────────────────────────────────
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPost",
		opts = {},
	},

	-- ── Trouble (diagnostics panel) ───────────────
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix" },
		},
		opts = { use_diagnostic_signs = true },
	},

	-- ── Todo highlights ───────────────────────────
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		opts = {},
		keys = { { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo" } },
	},

	-- ── Markdown preview ──────────────────────────
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
		ft = { "markdown" },
		build = "cd app && npm install",
	},
}
