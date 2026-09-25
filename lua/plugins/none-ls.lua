local function project_root(params) return vim.fs.root(params.bufname, "pyproject.toml") end

local function venv_bin(name)
  return function(params)
    local root = project_root(params)
    local exe = root and root .. "/.venv/bin/" .. name
    return exe and vim.fn.executable(exe) == 1 and exe or nil
  end
end

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  opts = function(_, opts)
    local null_ls = require "null-ls"
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      null_ls.builtins.diagnostics.mypy.with { dynamic_command = venv_bin "mypy", cwd = project_root },
      require("none-ls.diagnostics.flake8").with { dynamic_command = venv_bin "flake8", cwd = project_root },
    })
  end,
}
