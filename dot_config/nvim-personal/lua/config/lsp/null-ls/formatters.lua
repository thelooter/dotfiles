local M = {}

local utils = require "utils"
local nls_utils = require "config.lsp.null-ls.utils"
local nls_sources = require "null-ls.sources"

local method = require("null-ls").methods.FORMATTING

M.autoformat = true

function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    utils.info("Enabled format on save", "Formatting")
  else
    utils.warn("Disabled format on save", "Formatting")
  end
end

-- Use null-ls when it has a formatter for the filetype, otherwise the language server
function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local use_nls = M.has_formatter(vim.bo[bufnr].filetype)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return (client.name == "null-ls") == use_nls
    end,
  })
end

local augroup_formatting = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

function M.setup(_, buf)
  vim.api.nvim_clear_autocmds({ group = augroup_formatting, buffer = buf })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup_formatting,
    buffer = buf,
    callback = function()
      if M.autoformat then
        M.format(buf)
      end
    end,
  })
end

function M.has_formatter(filetype)
  local available = nls_sources.get_available(filetype, method)
  return #available > 0
end

function M.list_registered(filetype)
  local registered_providers = nls_utils.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

function M.list_supported(filetype)
  local supported_formatters = nls_sources.get_supported(filetype, "formatting")
  table.sort(supported_formatters)
  return supported_formatters
end

return M
