return {
  n = {
    -- second key is the lefthand side of the map
    -- Tab Mappings
    ["<leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>Tx"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
    -- a table with the `name` key will register with which-key if it's available
    -- this an easy way to add menu titles in which-key
    ["<leader>T"] = { name = "Tab" },
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
    ["<leader>O"] = { name = " Octo" },
    ["<leader>Oil"] = { "<cmd>Octo issue list<CR>", desc = "List issues" },
    ["<leader>OiC"] = { "<cmd>Octo issue create<CR>", desc = "Create new issue" },
    ["<leader>Oic"] = { "<cmd>Octo issue comment<CR>", desc = "Comment on issue" },
    ["<leader>Opl"] = { "<cmd>Octo pr list<CR>", desc = "List PRs" },
    ["<leader>OpC"] = { "<cmd>Octo pr create<CR>", desc = "Create new PR" },
    ["<leader>Ooc"] = { "<cmd>Octo pr comment<CR>", desc = "Comment on PR" },
  },
  t = {
    -- setting a mapping to false will disable it
  },
}
