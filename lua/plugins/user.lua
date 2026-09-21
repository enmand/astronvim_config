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

  -- Extend community nvim-coverage opts (merged, not shadowing)
  {
    "andythigpen/nvim-coverage",
    opts = {
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
    },
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
    "yetone/avante.nvim",
    -- these ACP commands are not in the astrocommunity lazy loading list
    cmd = { "AvanteACPModels", "AvanteACPModes" },
    opts = {
      rag_service = {
        enabled = false,
      },
      provider = "claude-code",
      acp_providers = {
        -- @zed-industries/claude-agent-acp: only PATH is inherited from Neovim, so HOME must
        -- be passed explicitly or auth lookup fails with "Authentication required".
        -- Do NOT set CLAUDE_CODE_EXECUTABLE: the agent passes it to the Agent SDK as
        -- `pathToClaudeCodeExecutable` while spawning it with node, and our `claude` is a
        -- native binary, not a cli.js. It bundles its own claude-code CLI, so leave it alone.
        ["claude-code"] = {
          command = "claude-agent-acp",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            HOME = os.getenv "HOME",
            PATH = os.getenv "PATH",
          },
        },
        codex = {
          command = "codex",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            HOME = os.getenv "HOME",
            PATH = os.getenv "PATH",
          },
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>Am"] = { "<Cmd>AvanteACPModels<CR>", desc = "Select ACP model" },
              ["<Leader>AM"] = { "<Cmd>AvanteACPModes<CR>", desc = "Select ACP mode" },
            },
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
  {
    -- AI sidekick: Copilot NES + terminal panel for Claude/Codex/opencode CLIs.
    -- Lowercase `<Leader>a` prefix avoids clashing with Avante's `<Leader>A`.
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = assert(opts.mappings)
          local prefix = "<Leader>a"
          maps.n[prefix] = { desc = "Sidekick" }
          maps.n[prefix .. "a"] = { function() require("sidekick.cli").toggle() end, desc = "Toggle CLI" }
          maps.n[prefix .. "s"] = { function() require("sidekick.cli").select() end, desc = "Select CLI" }
          maps.n[prefix .. "d"] = { function() require("sidekick.cli").close() end, desc = "Detach CLI session" }
          maps.n[prefix .. "t"] = {
            function() require("sidekick.cli").send { msg = "{this}" } end,
            desc = "Send this to CLI",
          }
          maps.n[prefix .. "f"] = {
            function() require("sidekick.cli").send { msg = "{file}" } end,
            desc = "Send file to CLI",
          }
          maps.n[prefix .. "p"] = { function() require("sidekick.cli").prompt() end, desc = "Select prompt" }
          maps.n[prefix .. "c"] = {
            function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
            desc = "Toggle Claude",
          }
          maps.n[prefix .. "n"] = { desc = "NES" }
          maps.n[prefix .. "nt"] = { function() require("sidekick.nes").toggle() end, desc = "Toggle NES" }
          maps.n[prefix .. "nu"] = { function() require("sidekick.nes").update() end, desc = "Update suggestions" }
          maps.x[prefix] = { desc = "Sidekick" }
          maps.x[prefix .. "v"] = {
            function() require("sidekick.cli").send { msg = "{selection}" } end,
            desc = "Send selection to CLI",
          }
          maps.x[prefix .. "p"] = { function() require("sidekick.cli").prompt() end, desc = "Select prompt" }
          for _, mode in ipairs { "n", "x", "i", "t" } do
            maps[mode] = maps[mode] or {}
            maps[mode]["<C-.>"] = { function() require("sidekick.cli").toggle() end, desc = "Sidekick toggle" }
          end
        end,
      },
      {
        -- Insert sidekick NES into blink's <Tab> chain (after snippets, before fallback)
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
          local tab = assert(opts.keymap)["<Tab>"]
          table.insert(tab, #tab, function() return require("sidekick").nes_jump_or_apply() end)
        end,
      },
      {
        -- Send snacks picker selections to the CLI with <A-a>
        "folke/snacks.nvim",
        optional = true,
        opts = function(_, opts)
          local actions = vim.tbl_get(opts, "picker", "actions") or {}
          actions.sidekick_send = function(...) return require("sidekick.cli.picker.snacks").send(...) end
          opts.picker = opts.picker or {}
          opts.picker.actions = actions
          local keys = vim.tbl_get(opts, "picker", "win", "input", "keys") or {}
          keys["<a-a>"] = { "sidekick_send", mode = { "n", "i" } }
          opts.picker.win = opts.picker.win or {}
          opts.picker.win.input = opts.picker.win.input or {}
          opts.picker.win.input.keys = keys
        end,
      },
    },
  },
}
