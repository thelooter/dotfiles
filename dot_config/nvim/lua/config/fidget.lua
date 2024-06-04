local M = {}

function M.setup()
  require("fidget").setup {
    progress = {
      display = {
        render_limit = 8,
      },
    },
    notification = {
      window = {
        winblend = 0

      }
    }
  }
end

return M
