local M = {}

function M.setup()
  require("copilot").setup {
    suggestions = {
      enabled = false,
      auto_trigger = true,
      keymap = {
        accept = "<C-y>",
        next = "<A-k>",
        previous = "<A-j>",
        dismiss = "<A-d>"
      }
    },
    panel = {
      enabled = false
    }
  }
end

return M
