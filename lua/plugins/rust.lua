-- rust-analyzer is driven by rustaceanvim, and rustaceanvim reads its config
-- from `vim.lsp.config["rust-analyzer"]` (dash). The astrocommunity rust pack
-- builds rustaceanvim's `settings` as a function and pulls `config.rust_analyzer`
-- in via `astrolsp.lsp_opts`, which this AstroNvim v5 install does not provide,
-- so every `astrolsp` rust-analyzer setting is silently dropped. Configure it
-- natively here so the settings actually reach the server.
return {
  "mrcjkb/rustaceanvim",
  init = function()
    vim.lsp.config("rust-analyzer", {
      settings = {
        ["rust-analyzer"] = {
          -- rust-analyzer server-watches the project; keep `target`/`result`
          -- out of the watch set or it loops on its own build output and the
          -- "Roots Scanned" progress never ends.
          files = {
            -- `excludeDirs` is the pre-2024 name and is silently ignored;
            -- the key rust-analyzer actually reads is `exclude`.
            exclude = { ".direnv", ".git", "target", "result" },
            -- Watch server-side. rustaceanvim only sets this via a heuristic,
            -- and Neovim's own watcher chokes on big trees, which is what made
            -- new files and new deps invisible until a restart.
            watcher = "server",
          },
          -- Make the on-save check far cheaper. rust-analyzer has no real
          -- "debounce" knob (check only runs on save, never per-keystroke),
          -- so we shrink the work each save does instead:
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
            workspace = true, -- check every workspace member, not just the current crate
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
    })
  end,
}
