local M = {}

local nls = require("null-ls")
local nls_utils = require("null-ls.utils")
local b = nls.builtins

local sources = {
  -- formatting
  b.formatting.prettierd,
  b.formatting.shfmt,
  b.formatting.black.with({ extra_args = { "--fast" } }),
  b.formatting.isort,
  b.formatting.stylua,
  b.formatting.shfmt,
  b.formatting.shellharden,
  b.formatting.prettier,
  b.formatting.goimports_reviser,
  b.formatting.gofumpt,
  b.formatting.golines,
  b.formatting.npm_groovy_lint,
  require("none-ls.formatting.latexindent"),
  -- diagnostics
  b.diagnostics.markdownlint,
  -- b.diagnostics.eslint_d,
  b.diagnostics.selene,
  b.diagnostics.ansiblelint,
  b.diagnostics.zsh,
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
  nls.setup({
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern(".git"),
  })
end

return M
