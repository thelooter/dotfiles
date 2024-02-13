local M = {}

function M.setup()
  require("catppuccin").setup({
    flavour = "frappe",
    transparent_background = true,
    integrations = {
      mason = true,
      neotree = true,
      neotest = true,
      noice = true,
      symbols_outline = true,
      lsp_trouble = true,
      which_key = true,
      lsp_saga = true,
      octo = true,
      navic = {
        enabled = true,
        custom_bg = "NONE"
      },
      notify = true
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
  })
end

return M
