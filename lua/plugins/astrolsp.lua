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
      -- rust-analyzer-style auto-import: offer unimported symbols (incl. every
      -- package.json dep, not just already-imported ones) in completion.
      vtsls = {
        settings = {
          typescript = {
            suggest = { autoImports = true, includeCompletionsForImportStatements = true },
            preferences = { includePackageJsonAutoImports = "on", importModuleSpecifier = "shortest" },
          },
          javascript = {
            suggest = { autoImports = true, includeCompletionsForImportStatements = true },
            preferences = { includePackageJsonAutoImports = "on", importModuleSpecifier = "shortest" },
          },
          vtsls = {
            experimental = { completion = { enableServerSideFuzzyMatch = true, entriesLimit = 200 } },
          },
        },
      },
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
        -- Hover with the definition's location (file:line) prepended, for any server.
        K = {
          function()
            local params = function(client) return vim.lsp.util.make_position_params(0, client.offset_encoding) end
            vim.lsp.buf_request_all(0, "textDocument/hover", params, function(hovers)
              vim.lsp.buf_request_all(0, "textDocument/definition", params, function(defs)
                local lines = {}
                for _, r in pairs(defs) do
                  local loc = r.result and (vim.islist(r.result) and r.result[1] or r.result)
                  if loc then
                    local range = loc.targetSelectionRange or loc.range
                    local file = vim.fn.fnamemodify(vim.uri_to_fname(loc.targetUri or loc.uri), ":~:.")
                    lines = { ("`%s:%d`"):format(file, range.start.line + 1), "---" }
                    break
                  end
                end
                local has_hover = false
                for _, r in pairs(hovers) do
                  if r.result and r.result.contents then
                    if has_hover then table.insert(lines, "---") end
                    vim.list_extend(lines, vim.lsp.util.convert_input_to_markdown_lines(r.result.contents))
                    has_hover = true
                  end
                end
                if not has_hover then return vim.notify("No information available", vim.log.levels.INFO) end
                vim.lsp.util.open_floating_preview(lines, "markdown", { focus_id = "textDocument/hover" })
              end)
            end)
          end,
          desc = "Hover symbol details (with definition location)",
          cond = "textDocument/hover",
        },
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
