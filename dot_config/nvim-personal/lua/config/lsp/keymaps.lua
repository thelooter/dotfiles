local M = {}

local whichkey = require("which-key")

local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap("n", "pd", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "nd", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "pe", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  keymap("n", "ne", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

  -- Whichkey
  local keymap_l = {
    {"<leader>l", group = "Code", buffer = bufnr},
    -- {"<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action", buffer = bufnr},
    {"<leader>lI", "<cmd>LspInfo<CR>", desc = "Lsp Info", buffer = bufnr},
    {"<leader>li", "<cmd>Telescope lsp_implementations<CR>", desc = "Implementations", buffer = bufnr},
    {"<leader>ld", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics", buffer = bufnr},
    {"<leader>lf", "<cmd>Lspsaga lsp_finder<CR>", desc = "Finder", buffer = bufnr},
    {"<leader>ln", "<cmd>Lspsaga rename<CR>", desc = "Rename", buffer = bufnr},
    {"<leader>lh", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Doc", buffer = bufnr},
    {"<leader>lr", "<cmd>Telescope lsp_references<CR>", desc = "References", buffer = bufnr},
    {"<leader>lt", "<cmd>Trouble toggle diagnostics<CR>", desc = "Trouble", buffer = bufnr},
  }
  
  if client.server_capabilities.document_formatting then
    table.insert(keymap_l, {"<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", desc = "Format Document", buffer = bufnr})
  end

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
