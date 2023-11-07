local M = {}

function M.setup()
  require("bufferline").setup {
    options = {
      numbers = "ordinal",
      diagnostics = "nvim_lsp" or "coc",
      separator_style = "slope" or "padded_slanuut",
      show_tab_indicators = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          separator = false,
          text_align = "left",
          highlight = "Directory"
        }
      },
      custom_filter = function(buf_number, buf_numbers)
        local tab_num = 0
        for _ in pairs(vim.api.nvim_list_tabpages()) do
          tab_num = tab_num + 1
        end

        if tab_num > 1 then
          if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
            return true
          end
        else
          return true
        end
      end
    }
  }
end

return M
