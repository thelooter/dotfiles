local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "#{m} [#{c}]",
  }
end

local with_root_file = function(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  }
end

local sources = {
  -- formatting
  b.formatting.prettierd,
  b.formatting.shfmt,
  b.formatting.black.with { extra_args = { "--fast" } },
  b.formatting.isort,
  with_root_file(b.formatting.stylua, "stylua.toml"),
  b.formatting.shfmt,
  b.formatting.shellharden,
  b.formatting.prettier,
  b.formatting.goimports_reviser,
  b.formatting.gofumpt,
  b.formatting.golines,
  b.formatting.npm_groovy_lint,

  -- diagnostics
  b.diagnostics.write_good,
  b.diagnostics.codespell,
  -- b.diagnostics.markdownlint,
  -- b.diagnostics.eslint_d,
  with_root_file(b.diagnostics.selene, "selene.toml"),
  b.diagnostics.zsh,
  b.diagnostics.ansiblelint,
  -- b.diagnostics.editorconfig_checker,

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,
  b.code_actions.refactoring,
  b.code_actions.proselint,

  -- hover
  b.hover.dictionary,
}

function M.setup(opts)
  nls.setup {
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern ".git",
  }
end

return M
