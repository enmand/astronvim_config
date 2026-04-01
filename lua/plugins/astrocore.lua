-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- Treesitter configuration (v6: managed via AstroCore instead of nvim-treesitter opts)
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "lua",
        "vim",
      },
    },
    -- vim options can be configured here
    options = {
      opt = {
        relativenumber = false,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        expandtab = true,
        autoindent = true,
        smartindent = true,
      },
      g = {},
    },
    -- Enable spell checking for prose filetypes
    autocmds = {
      spell_prose = {
        {
          event = "FileType",
          pattern = { "markdown", "text", "gitcommit", "plaintex", "tex" },
          desc = "Enable spell checking for prose filetypes",
          callback = function() vim.opt_local.spell = true end,
        },
      },
    },
    mappings = {
      n = {
        ["<Leader>T"] = { name = "Tab" },
        ["<Leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<Leader>Tx"] = { "<cmd>tabclose<cr>", desc = "Close tab" },

        ["<D-t>"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<D-w>"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
        ["<D-]>"] = { "<cmd>tabnext<cr>", desc = "Next tab" },
        ["<D-[>"] = { "<cmd>tabprevious<cr>", desc = "Previous tab" },
        ["<C-x>"] = { "<cmd>bd<CR>" },

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Custom keybindings
        ["<S-D-e>"] = {
          function() require("neo-tree.command").execute { toggle = true } end,
          desc = "Toggle Neo-tree",
        },
        ["<C-n>"] = { function() require("neo-tree.command").execute { toggle = true } end, desc = "Toggle Neo-tree" },
        ["<C-p>"] = { function() require("snacks.picker").files() end, desc = "Find files" },
        ["<C-a>"] = { function() require("snacks.picker").grep() end, desc = "Find words" },
        ["<D-j>"] = { function() require("toggleterm").toggle() end, desc = "Toggle terminal" },

        -- Toggle bufferline mode between tabs and buffers
        ["<Leader>bt"] = {
          function()
            local bl = require "bufferline"
            local current_mode = require("bufferline.config").options.mode
            local new_mode = current_mode == "tabs" and "buffers" or "tabs"

            bl.setup {
              options = vim.tbl_extend("force", require("bufferline.config").options, { mode = new_mode }),
            }

            print("Bufferline mode: " .. new_mode)
          end,
          desc = "Toggle bufferline tabs/buffers mode",
        },
      },
    },
  },
}
