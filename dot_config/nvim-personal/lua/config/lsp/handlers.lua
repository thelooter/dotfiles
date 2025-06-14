local M = {}

function M.setup()

  local lsp = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded"
    },

    diagnostic = {
      virtual_text = {
        spacing = 4,
        prefix = "●"
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded"
      },
    }
  }

  local diagnostic_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  -- Set diagnostic signs using vim.diagnostic.config
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostic_signs[1].text,
        [vim.diagnostic.severity.WARN]  = diagnostic_signs[2].text,
        [vim.diagnostic.severity.HINT]  = diagnostic_signs[3].text,
        [vim.diagnostic.severity.INFO]  = diagnostic_signs[4].text,
      },
    },
  })

  -- diagnostic config
  vim.diagnostic.config(lsp.diagnostic)

  -- Hover config
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require("noice.lsp.hover").on_hover,lsp.float)

  --Signature help config
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(require("noice.lsp.signature"), lsp.float)

end

return M
