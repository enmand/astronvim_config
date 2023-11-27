return {
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
    { import = "astrocommunity.pack.helm"},
    { import = "astrocommunity.pack.go"},
    { import = "astrocommunity.pack.rust"},
    { import = "astrocommunity.pack.proto"},
    { import = "astrocommunity.pack.terraform"},
    { import = "astrocommunity.pack.typescript"},
    { import = "astrocommunity.pack.json"},
    { import = "astrocommunity.pack.yaml"},
    { import = "astrocommunity.scrolling.neoscroll-nvim"},
    { import = "astrocommunity.lsp.lsp-inlayhints-nvim"},
    { import = "astrocommunity.completion.copilot-lua" },
    { import = "astrocommunity.completion.copilot-lua-cmp" },
    { import = "astrocommunity.git.octo-nvim" },
    { import = "astrocommunity.git.git-blame-nvim" },
    { import = "astrocommunity.git.neogit" },
    { import = "astrocommunity.utility.neodim"},
    { import = "astrocommunity.test.neotest"},
    { import = "astrocommunity.terminal-integration.vim-tmux-yank" },
    { import = "astrocommunity.test.nvim-coverage"},
  },
  {"ray-x/go.nvim",
    config = function() require("go").setup({
      lsp_inlay_hints = { enable = false}
    }) end
  },
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
  { "vim-scripts/confirm-quit", lazy = false },
  { "goolord/alpha-nvim", enabled = false },
  { "Darazaki/indent-o-matic", enabled = false },
}
