-- ─────────────────────────────────────────────
--  plugins/langs/latex.lua  –  LaTeX / paper writing
-- ─────────────────────────────────────────────

return {
	-- ── vimtex: compile, view, SyncTeX ───────────
	{
		"lervag/vimtex",
		lazy = false, -- must load early for filetype detection
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = ".build",
				out_dir = ".build",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-pdf",
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
			vim.g.vimtex_quickfix_mode = 0 -- don't auto-open quickfix
			vim.g.vimtex_mappings_prefix = "\\"
			-- Disable insert-mode mappings that clash with your cmp setup
			vim.g.vimtex_imaps_enabled = 0
			vim.g.vimtex_format_enabled = 0 -- disable autoformatting
		end,
	},

	-- ── cmp-vimtex: cite/ref autocomplete ────────
	{
		"micangl/cmp-vimtex",
		ft = { "tex", "bib" },
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local cmp = require("cmp")
			cmp.setup.filetype({ "tex", "bib" }, {
				sources = cmp.config.sources({
					{ name = "vimtex", priority = 1000 },
					{ name = "luasnip", priority = 900 },
					{ name = "nvim_lsp", priority = 800 },
					{ name = "path", priority = 700 },
				}, {
					{ name = "buffer", keyword_length = 3 },
				}),
			})
		end,
	},

	-- ── LuaSnip LaTeX snippets ────────────────────
	{
		"L3MON4D3/LuaSnip",
		ft = { "tex" },
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node
			local rep = require("luasnip.extras").rep -- mirrors an earlier node
			local fmt = require("luasnip.extras.fmt").fmt

			ls.add_snippets("tex", {
				-- Environments
				s("beg", fmt("\\begin{{{}}}\n\t{}\n\\end{{{}}}", { i(1), i(2), rep(1) })),
				s("eq", fmt("\\begin{{equation}}\n\t{}\n\\end{{equation}}", { i(1) })),
				s("ali", fmt("\\begin{{align}}\n\t{}\n\\end{{align}}", { i(1) })),
				s(
					"fig",
					fmt(
						"\\begin{{figure}}[htbp]\n\t\\centering\n\t\\includegraphics[width={}\\textwidth]{{{}}}\n\t\\caption{{{}}}\n\t\\label{{fig:{}}}\n\\end{{figure}}",
						{ i(1, "0.8"), i(2, "path"), i(3, "caption"), i(4, "label") }
					)
				),

				-- Math
				s("frac", fmt("\\frac{{{}}}{{{}}}", { i(1, "num"), i(2, "den") })),
				s("sum", fmt("\\sum_{{{}}}^{{{}}} {}", { i(1, "i=0"), i(2, "n"), i(3) })),
				s("int", fmt("\\int_{{{}}}^{{{}}} {} \\,d{}", { i(1), i(2), i(3), i(4, "x") })),
				s("lim", fmt("\\lim_{{{}}} {}", { i(1, "n \\to \\infty"), i(2) })),
				s("vec", fmt("\\mathbf{{{}}}", { i(1) })),
				s("hat", fmt("\\hat{{{}}}", { i(1) })),
				s("bar", fmt("\\bar{{{}}}", { i(1) })),
				s("inf", t("\\infty")),
				s("tt", fmt("\\text{{{}}}", { i(1) })),

				-- Inline / display math
				s("mk", fmt("${}$", { i(1) })),
				s("dm", fmt("\\[\n\t{}\n\\]", { i(1) })),

				-- Structure
				s("sec", fmt("\\section{{{}}}", { i(1) })),
				s("ssec", fmt("\\subsection{{{}}}", { i(1) })),
				s("sssec", fmt("\\subsubsection{{{}}}", { i(1) })),
				s("cite", fmt("\\cite{{{}}}", { i(1) })),
				s("ref", fmt("\\ref{{{}}}", { i(1) })),
				s("lbl", fmt("\\label{{{}}}", { i(1) })),

				-- Lists
				s("item", fmt("\\begin{{itemize}}\n\t\\item {}\n\\end{{itemize}}", { i(1) })),
				s("enum", fmt("\\begin{{enumerate}}\n\t\\item {}\n\\end{{enumerate}}", { i(1) })),
			})
		end,
	},

	-- ── texlab: LSP for LaTeX ─────────────────────
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "texlab" })
		end,
	},

	-- ── LSP config for texlab ─────────────────────
	{
		"neovim/nvim-lspconfig",
		opts = function()
			vim.lsp.config("texlab", {
				settings = {
					texlab = {
						build = { onSave = false },
						chktex = { onOpenAndSave = true },
					},
				},
			})
			vim.lsp.enable("texlab")
		end,
	},
}
