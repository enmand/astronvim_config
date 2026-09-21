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
      disabled = {},
      timeout_ms = 1000,
    },
    -- enable servers that you already have installed without mason
    servers = {
      "tilt_ls",
    },
    -- customize language server configuration passed to `vim.lsp.config`
    config = {
      -- rust-analyzer tuning. These settings flow into rustaceanvim via the
      -- astrocommunity rust pack (it reads vim.lsp.config.rust_analyzer.settings)
      -- and deep-merge with the pack's defaults (which set check.command = clippy).
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            -- Make the on-save check far cheaper. rust-analyzer has no real
            -- "debounce" knob (check only runs on save, never per-keystroke),
            -- so we shrink the work each save does instead:
            check = {
              workspace = true, -- only check the crate you're in, not every workspace member
              allTargets = true, -- include tests/benches/examples so test code gets diagnostics
            },
            -- Keep inlay hints on, but drop the chattiest/most expensive categories.
            inlayHints = {
              parameterHints = { enable = false },
              chainingHints = { enable = false },
              closureReturnTypeHints = { enable = "never" },
              bindingModeHints = { enable = false },
              closingBraceHints = { enable = false },
            },
            -- Keep codelens, but only the cheap run/debug lenses. The reference
            -- and implementation lenses are the expensive ones.
            lens = {
              enable = true,
              run = { enable = true },
              debug = { enable = true },
              implementations = { enable = false },
              references = {
                adt = { enable = false },
                enumVariant = { enable = false },
                method = { enable = false },
                trait = { enable = false },
              },
            },
          },
        },
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
