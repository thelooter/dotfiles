local M = {}

function M.setup()
  require("noice").setup {
    presets = {
      command_palette = true,
      bottom_search = true,
    },
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  }
end

return M
