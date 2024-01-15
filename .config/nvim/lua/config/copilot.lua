local M = {}

function M.setup()
  require("copilot").setup {
    suggestions = {
      enabled = true,
      auto_trigger = false,
      keymap = {
        accept = "<C-y>",
        next = "<A-k>",
        previous = "<A-j>",
        dismiss = "<A-d>"
      }
    },
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-L>"
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
      },
    },
  }
end

return M
