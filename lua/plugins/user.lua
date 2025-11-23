---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    commit = false, -- Override AstroNvim's lazy_snapshot pinning
    build = ":TSUpdate",
  },

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
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

  -- Configure neotest-golang to generate coverage when running tests
  -- The opts are passed via astrocore.plugin_opts when the adapter is registered
  {
    "fredrikaverpil/neotest-golang",
    lazy = true,
    opts = {
      go_test_args = function()
        return {
          "-v",
          "-race",
          "-count=1",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        }
      end,
    },
  },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  {
    "andythigpen/nvim-coverage",
    config = function()
      require("coverage").setup {
        auto_reload = true,
        lang = {
          go = {
            coverage_file = vim.fn.getcwd() .. "/coverage.out",
          },
        },
      }
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
  {
    "yetone/avante.nvim",
    opts = {
      rag_service = {
        enabled = true, -- Enables the RAG service
        host_mount = os.getenv "HOME" .. "/Code", -- Host mount path for the rag service
        provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
        llm_model = "", -- The LLM model to use for RAG service
        embed_model = "", -- The embedding model to use for RAG service
        endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
      },
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          command = "npx",
          args = { "@zed-industries/claude-code-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            CLAUDE_CODE_OAUTH_TOKEN = os.getenv "CLAUDE_CODE_OAUTH_TOKEN",
            ANTHROPIC_API_KEY = os.getenv "ANTHROPIC_API_KEY",
            ACP_PERMISSION_MODE = "bypassPermissions",
          },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match "error" and " " or " "
          return " " .. icon .. count
        end,
        mode = "tabs",
        separator_style = "slant",
        diagnostics_update_in_insert = false,
      },
    },
  },
}
