-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

	-- == Examples of Adding Plugins ==
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},

	{
		"andythigpen/nvim-coverage",
		opts = {
			lang = {
				rust = {
					coverage_command =
					"grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
					project_files_only = true,
					project_files = { "crates/*", "src/*", "tests/*" },
				},
			},
		},
	},

	-- == Examples of Overriding Plugins ==
	-- customize alpha options
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			-- customize the dashboard header
			opts.section.header.val = {
				" █████  ███████ ████████ ██████   ██████",
				"██   ██ ██         ██    ██   ██ ██    ██",
				"███████ ███████    ██    ██████  ██    ██",
				"██   ██      ██    ██    ██   ██ ██    ██",
				"██   ██ ███████    ██    ██   ██  ██████",
				" ",
				"    ███    ██ ██    ██ ██ ███    ███",
				"    ████   ██ ██    ██ ██ ████  ████",
				"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
				"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
				"    ██   ████   ████   ██ ██      ██",
			}
			return opts
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = function(_, opts)
			-- Other blankline configuration here
			return require("indent-rainbowline").make_opts(opts, {
				color_transparency = 0.05,
			})
		end,
		dependencies = {
			"TheGLander/indent-rainbowline.nvim",
		},
	},
	{ "max397574/better-escape.nvim", enabled = false },

	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
					-- don't add a pair if the next character is %
						:with_pair(cond.not_after_regex("%%"))
					-- don't add a pair if  the previous character is xxx
						:with_pair(
							cond.not_before_regex("xxx", 3)
						)
					-- don't move right when repeat character
						:with_move(cond.none())
					-- don't delete if the next character is xx
						:with_del(cond.not_after_regex("xx"))
					-- disable adding a newline when you press <cr>
						:with_cr(cond.none()),
				},
				-- disable for .vim files, but it work for another filetypes
				Rule("a", "a", "-vim")
			)
		end,
	},
	{
		"karb94/neoscroll.nvim",
		opt = true,
		setup = function()
			table.insert(astronvim.file_plugins, "neoscroll.nvim")
		end,
		config = function()
			local M = {}

			function M.config()
				local status_ok, neoscroll = pcall(require, "neoscroll")
				if not status_ok then
					return
				end

				neoscroll.setup(require("core.utils").user_plugin_opts("plugins.neoscroll", {
					-- All these keys will be mapped to their corresponding default scrolling animation
					mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					easing_function = nil, -- Default easing function
					pre_hook = nil, -- Function to run before the scrolling animation starts
					post_hook = nil, -- Function to run after the scrolling animation ends
				}))
			end

			return M
		end,
	},
	{
		"nvim-neotest/neotest",
		config = function()
			local neotest_golang_opts = { -- Specify configuration
				runner = "go",
				go_test_args = {
					"-v",
					"-race",
					"-count=1",
					"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
				},
			}
			require("neotest").setup({
				adapters = {
					require("neotest-golang")(neotest_golang_opts), -- Registration
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "sqlfluff" })
			opts.handlers = opts.handlers or {}

			opts.handlers.sqlfluff = function()
				local null_ls = require("null-ls")
				null_ls.register(null_ls.builtins.diagnostics.sqlfluff.with({
					extra_args = { "--dialect", "postgres" },
				}))
				null_ls.register(null_ls.builtins.formatting.sqlfluff.with({
					extra_args = { "--dialect", "postgresql" },
				}))
			end
		end,
	},
	{
		"andythigpen/nvim-coverage",
		config = function()
			require("coverage").setup({
				auto_reload = true,
				lang = {
					go = {
						coverage_file = vim.fn.getcwd() .. "/coverage.out",
					},
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
		},
	},
	{
		"yetone/avante.nvim",
		opts = {
			rag_service = {
				enabled = true,                -- Enables the RAG service
				host_mount = os.getenv("HOME") .. "/Code", -- Host mount path for the rag service
				provider = "openai",           -- The provider to use for RAG service (e.g. openai or ollama)
				llm_model = "",                -- The LLM model to use for RAG service
				embed_model = "",              -- The embedding model to use for RAG service
				endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			direction = "float",
		},
	},
	{
		"cappyzawa/starlark.vim",
	},
}
