local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_get_option_value, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name })
end

return M
