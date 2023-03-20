return {
  "onsails/lspkind.nvim",
  opts = function(_, opts)
    -- use codicons preset
    -- set some missing symbol types
    opts.symbol_map = {
      Copilot = "",
    }
    return opts
  end,
}
