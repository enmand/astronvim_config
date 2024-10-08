-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        expandtab = true,
        autoindent = true,
        smartindent = true,
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      v = {
        -- ["<D-v>"] = { '"+P' }, -- Paste visual mode
      },
      c = {
        -- ["<D-v>"] = { "<C-R>+" }, -- Paste command mode
      },
      i = {
        -- ["<D-s>"] = { "<Esc>:w<CR>" },
        -- ["<D-v>"] = { "<C-R>+" }, -- Paste insert mode
      },
      n = {
        -- ["<D-s>"] = { ":w<CR>" },
        -- ["<D-c>"] = { '"+y' },
        -- ["<D-v>"] = { '"+P' }, -- Paste normal mode

        -- second key is the lefthand side of the map
        -- Tab Mappings
        ["<Leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<Leader>Tx"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
        -- a table with the `name` key will register with which-key if it's available
        -- this an easy way to add menu titles in which-key
        ["<Leader>T"] = { name = "Tab" },
        -- quick save
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
        ["<C-p>"] = { "<cmd>Telescope find_files<CR>" },
        [",A"] = { "<cmd>Telescope live_grep<CR>" },
        [",a"] = { "<cmd>Telescope live_grep<CR>" },
        ["<C-a>"] = { "<cmd>Telescope live_grep<CR>" },
        ["<C-b>"] = { "<cmd>Neotree toggle<CR>" },
        ["<C-x>"] = { "<cmd>bd<CR>" },
        ["<C-j>"] = { "<cmd>ToggleTerm<CR>" },
        -- Octo
        ["<Leader>O"] = { name = " Octo" },
        ["<Leader>Oil"] = { "<cmd>Octo issue list<CR>", desc = "List issues" },
        ["<Leader>OiC"] = { "<cmd>Octo issue create<CR>", desc = "Create new issue" },
        ["<Leader>Oic"] = { "<cmd>Octo issue comment<CR>", desc = "Comment on issue" },
        ["<Leader>Opl"] = { "<cmd>Octo pr list<CR>", desc = "List PRs" },
        ["<Leader>OpC"] = { "<cmd>Octo pr create<CR>", desc = "Create new PR" },
        ["<Leader>Ooc"] = { "<cmd>Octo pr comment<CR>", desc = "Comment on PR" },
      },
    },
  },
}
