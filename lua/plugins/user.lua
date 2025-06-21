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
					coverage_command = "grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
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
	-- {
	-- "ray-x/go.nvim",
	-- config = function()
	-- require("go").setup {
	-- lsp_inlay_hints = { enable = false },
	-- }
	-- end,
	-- },
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
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						-- concat require('astrocore').plugin_opts("neotest-go") to neotest-go options
						require("astrocore").plugin_opts("neotest-go"),
						experimental = {
							test_table = true,
						},
						args = {
							"-test.v -timeout=30s -count=1 -coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
						},
					}),
				},
			})
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
		commit = "87c4c6b4937d1884960759aba4a0e42645688f2f",
		opts = {
			rag_service = {
				enabled = true, -- Enables the RAG service
				host_mount = os.getenv("HOME") .. "/Code", -- Host mount path for the rag service
				provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
				llm_model = "", -- The LLM model to use for RAG service
				embed_model = "", -- The embedding model to use for RAG service
				endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
			},
		},
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
	-- {"hrsh7th/nvim-cmp",
	--   dependencies = {
	--     "hrsh7th/cmp-calc",
	--     "hrsh7th/cmp-emoji",
	--     "kdheepak/cmp-latex-symbols",
	--   },
	--   opts = function(_, opts)
	--     local cmp = require "cmp"
	--
	--     local function next_item()
	--       if cmp.visible() then
	--         cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
	--       else
	--         cmp.complete()
	--       end
	--     end
	--
	--     local has_words_before = function()
	--       if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
	--       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	--       return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
	--     end
	--
	--     return require("astronvim.utils").extend_tbl(opts, {
	--       sources = cmp.config.sources {
	--         { name = "nvim_lsp",      priority = 1000 },
	--         { name = "copilot",       priority = 900 },
	--         { name = "luasnip",       priority = 750 },
	--         { name = "latex_symbols", priority = 700 },
	--         { name = "emoji",         priority = 700 },
	--         { name = "calc",          priority = 650 },
	--         { name = "path",          priority = 500 },
	--         { name = "buffer",        priority = 250 },
	--       },
	--       mapping = {
	--         ["<C-n>"] = next_item,
	--         ["<C-j>"] = next_item,
	--         ["<Tab>"] = vim.schedule_wrap(function(fallback)
	--           if cmp.visible() and has_words_before() then
	--             cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
	--           else
	--             fallback()
	--           end
	--         end),
	--         ["<CR>"] = cmp.mapping.confirm({
	--           select = true,
	--           behavior = cmp.ConfirmBehavior.Replace,
	--         }),
	--       },
	--     })
	--   end,
	-- },
}
