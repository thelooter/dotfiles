local g = vim.g

PLUGINS = {
  coq = {
    enabled = false,
  },
  nvim_cmp = {
    enabled = true,
  },
  fzf_lua = {
    enabled = true,
  },
  telescope = {
    enabled = true,
  },
}

local disabled_built_ins = {
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "matchparen",
  "tar",
  "tarPlugin",
  "rrhelper",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
