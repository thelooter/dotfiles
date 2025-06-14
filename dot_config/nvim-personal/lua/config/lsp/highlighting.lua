local M = {}

local utils = require("utils")

M.highlight = true

function M.toggle()
  M.highlight = not M.highlight

  if M.highlight then
    utils.info("Enabled document highlight", "Document highlight")
  else
    utils.warn("Disabled document highlight", "Document highlight")
  end
end

function M.highlight(client)
  if M.highlight then
    if client.server_capabilities.document_highlight then
      local present, illuminate = pcall(require, "illuminate")
      if present then
        illuminate.onAttach(client)
      else
        vim.api.nvim_exec2(
          [[
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
          ]],
          {
            output = false,
          }
        )
      end
    end
  end
end

function M.setup(client)
  M.highlight(client)
end

return M
