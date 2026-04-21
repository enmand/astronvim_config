---@type LazySpec
return {

  { "ray-x/lsp_signature.nvim", enabled = false },

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
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
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
          rust = {
            coverage_command = "grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
            project_files_only = true,
            project_files = { "crates/*", "src/*", "tests/*" },
          },
        },
      }
    end,
  },

  -- Configure neotest-golang with coverage options
  {
    "nvim-neotest/neotest",
    dependencies = { "fredrikaverpil/neotest-golang" },
    opts = function(_, opts)
      if opts.adapters then
        local new_adapters = {}
        for _, adapter in ipairs(opts.adapters) do
          if type(adapter) ~= "table" or adapter.name ~= "neotest-golang" then table.insert(new_adapters, adapter) end
        end
        opts.adapters = new_adapters
      else
        opts.adapters = {}
      end
      table.insert(
        opts.adapters,
        require "neotest-golang" {
          go_test_args = function()
            return {
              "-v",
              "-race",
              "-count=1",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            }
          end,
        }
      )
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
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
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
  },
  {
    "yetone/avante.nvim",
    opts = {
      rag_service = {
        enabled = false,
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
            ACP_PERMISSION_MODE = "auto",
          },
        },
      },
    },
  },
  {
    "kevalin/mermaid.nvim",
    ft = { "markdown", "mermaid" },
    opts = {
      theme = "dark",
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      {
        "3rd/image.nvim",
        opts = {},
      },
    },
    ft = { "markdown", "mermaid" },
    enabled = function()
      -- Only enable when Kitty graphics protocol can work:
      -- not in Zellij/tmux, and not in a GUI like Neovide
      return not vim.g.neovide and vim.env.ZELLIJ == nil and vim.env.TMUX == nil
    end,
    opts = {
      renderer_options = {
        mermaid = {
          background = "transparent",
          theme = "dark",
          cli_args = { "-p", vim.fn.stdpath "config" .. "/puppeteer-config.json" },
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
          local icon = level:match "error" and " " or " "
          return " " .. icon .. count
        end,
        mode = "tabs",
        separator_style = "slant",
        diagnostics_update_in_insert = false,
      },
    },
  },
}
