-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      autoformat = true,
      codelens = true,
      inlay_hints = true,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = { "vtsls" },
      timeout_ms = 1000,
    },
    -- enable servers that you already have installed without mason
    servers = {
      "tilt_ls",
    },
    -- customize language server configuration passed to `vim.lsp.config`
    -- NOTE: rust-analyzer is configured in lua/plugins/rust.lua. Settings put in
    -- `config.rust_analyzer` here are dropped: astrocommunity's rust pack reads
    -- them via `astrolsp.lsp_opts`, which this AstroNvim install doesn't provide.
    config = {
      basedpyright = {
        -- Use the project's in-project Poetry venv; fall back to PATH python.
        before_init = function(_, c)
          local venv_py = c.root_dir and c.root_dir .. "/.venv/bin/python"
          local python = (venv_py and vim.fn.executable(venv_py) == 1) and venv_py or vim.fn.exepath "python"
          c.settings = vim.tbl_deep_extend("force", c.settings or {}, { python = { pythonPath = python } })
        end,
      },
    },
    handlers = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          -- Refresh on buffer enter and after writes, not on every InsertLeave
          -- (which fired a codelens request every time you left insert mode).
          event = { "BufEnter", "BufWritePost" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function(client, bufnr) end,
  },
}
