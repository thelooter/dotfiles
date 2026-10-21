local M = {}

local whichkey = require("which-key")

local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_keymap(bufnr, "n", "gp", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>", opts)
  buf_keymap(bufnr, "n", "gn", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>", opts)
  buf_keymap(bufnr, "n", "gP", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })<CR>", opts)
  buf_keymap(bufnr, "n", "gN", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })<CR>", opts)

  -- Whichkey
  local keymap_l = {
    {"<leader>l", group = "Code", buffer = bufnr},
    -- {"<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action", buffer = bufnr},
    {"<leader>lI", "<cmd>LspInfo<CR>", desc = "Lsp Info", buffer = bufnr},
    {"<leader>li", "<cmd>Telescope lsp_implementations<CR>", desc = "Implementations", buffer = bufnr},
    {"<leader>ld", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics", buffer = bufnr},
    {"<leader>lf", "<cmd>Lspsaga finder<CR>", desc = "Finder", buffer = bufnr},
    {"<leader>ln", "<cmd>Lspsaga rename<CR>", desc = "Rename", buffer = bufnr},
    {"<leader>lh", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Doc", buffer = bufnr},
    {"<leader>lr", "<cmd>Telescope lsp_references<CR>", desc = "References", buffer = bufnr},
    {"<leader>lt", "<cmd>Trouble toggle diagnostics<CR>", desc = "Trouble", buffer = bufnr},
    {"<leader>lF", function() require("config.lsp.null-ls.formatters").format(bufnr) end, desc = "Format Document", buffer = bufnr},
  }

  local keymap_g = {
    {"gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definition", buffer = bufnr},
    {"gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration", buffer = bufnr},
    {"gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature Help", buffer = bufnr},
    {"gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Goto Implementation", buffer = bufnr},
    {"gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto Type Definition", buffer = bufnr},
  }
  
  whichkey.add(keymap_l)
  whichkey.add(keymap_g)
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
