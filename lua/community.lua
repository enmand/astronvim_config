-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	-- { import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.recipes.heirline-vscode-winbar" },
	{ import = "astrocommunity.recipes.heirline-clock-statusline" },
	{ import = "astrocommunity.recipes.heirline-mode-text-statusline" },
	{ import = "astrocommunity.recipes.neovide" },
	{ import = "astrocommunity.pack.helm" },
	{ import = "astrocommunity.pack.golangci-lint" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.proto" },
	{ import = "astrocommunity.pack.terraform" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.pack.cs" },
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.scrolling.neoscroll-nvim" },
	{ import = "astrocommunity.recipes.vscode" },
	-- { import = "astrocommunity.indent.indent-rainbowline" },
	-- { import = "astrocommunity.lsp.lsp-inlayhints-nvim" },
	-- { import = "astrocommunity.completion.copilot-lua" },
	{ import = "astrocommunity.completion.copilot-lua-cmp" },
	{ import = "astrocommunity.completion.avante-nvim" },
	{ import = "astrocommunity.git.octo-nvim" },
	{ import = "astrocommunity.git.git-blame-nvim" },
	{ import = "astrocommunity.git.neogit" },
	-- { import = "astrocommunity.utility.neodim"},
	{ import = "astrocommunity.test.neotest" },
	{ import = "astrocommunity.test.nvim-coverage" },
	{ import = "astrocommunity.terminal-integration.vim-tmux-yank" },
	{ import = "astrocommunity.test.nvim-coverage" },
	-- import/override with your plugins folder
}
