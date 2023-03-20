return {
  {
    "karb94/neoscroll.nvim",
    opt = true,
    setup = function() table.insert(astronvim.file_plugins, "neoscroll.nvim") end,
    config = function()
      local M = {}

      function M.config()
        local status_ok, neoscroll = pcall(require, "neoscroll")
        if not status_ok then return end

        neoscroll.setup(require("core.utils").user_plugin_opts("plugins.neoscroll", {
          -- All these keys will be mapped to their corresponding default scrolling animation
          mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
          hide_cursor = true,          -- Hide cursor while scrolling
          stop_eof = true,             -- Stop at <EOF> when scrolling downwards
          use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
          respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
          cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
          easing_function = nil,       -- Default easing function
          pre_hook = nil,              -- Function to run before the scrolling animation starts
          post_hook = nil,             -- Function to run after the scrolling animation ends
        }))
      end

      return M
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    module = "lsp-inlayhints",
    config = function() require("lsp-inlayhints").setup() end,
    opts = {},
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  { "goolord/alpha-nvim",       enabled = false },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require('dap-go').setup()
    end
  },
  {
    "pwntester/octo.nvim",
    lazy = false,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
    end,
  },
  { "vim-scripts/confirm-quit", lazy = false },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
}
