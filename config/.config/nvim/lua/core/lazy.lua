-- ─────────────────────────────────────────────
--  core/lazy.lua  –  Plugin manager bootstrap
-- ─────────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- ── Core infrastructure ──────────────────────
	{ import = "plugins.ui" },
	{ import = "plugins.editor" },
	{ import = "plugins.lsp" }, -- LSP infra only (mason, none-ls, fidget)
	{ import = "plugins.completion" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.tools" }, -- Generic tools only (DAP core, lazygit, spectre, neotest)

	-- ── Language / workload packs ────────────────
	--  Drop a file in lua/plugins/langs/ and add a line here.
	--  Comment out any lang you don't need on a given machine.
	{ import = "plugins.langs.go" },
	{ import = "plugins.langs.rust" },
	{ import = "plugins.langs.c" },
	{ import = "plugins.langs.python" },
	-- { import = "plugins.langs.web" },
	-- { import = "plugins.langs.lua_lang" },
	{ import = "plugins.langs.kotlin" }, -- standalone Kotlin (LSP, ktlint, DAP, neotest)
	-- { import = "plugins.langs.android" }, -- Android extras: Gradle, ADB (needs kotlin above)
	-- { import = "plugins.langs.zig" },  -- uncomment to add Zig
}, {
	defaults = { lazy = true },
	install = { colorscheme = { "catppuccin" }, concurrency = 1 },
	checker = { enabled = true, notify = false },
	ui = { border = "rounded" },

	-- Disable lua rocks
	rocks = {
		enabled = false,
	},

	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
		git = { timeout = 180 },
	},
})
