local M = {}

-- The `main` branch dropped the `ensure_installed = "all"/"maintained"` option,
-- so we list the languages this config actually uses. Add more with
-- `:TSInstall <lang>` (or extend this list).
local ensure_installed = {
  "bash", "c", "cpp", "css", "dart", "diff", "dockerfile", "git_config",
  "git_rebase", "gitcommit", "gitignore", "go", "gomod", "gosum", "gowork",
  "html", "java", "javascript", "json", "jsonc", "lua", "luadoc", "markdown",
  "markdown_inline", "python", "query", "regex", "rust", "sql", "toml", "tsx",
  "typescript", "vim", "vimdoc", "yaml",
}

-- Restore the textobjects from the old (master-branch) config. On `main`,
-- textobjects ships no default keymaps — we wire them up manually against the
-- module functions. (lsp_interop/peek_definition_code was removed in the
-- rewrite, so the old <leader>df/<leader>dF peek maps are not restored.)
local function setup_textobjects()
  local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
  if not ok then
    return
  end

  textobjects.setup({
    select = { lookahead = true },
    move = { set_jumps = true }, -- record jumps in the jumplist
  })

  local select = require("nvim-treesitter-textobjects.select")
  local swap = require("nvim-treesitter-textobjects.swap")
  local move = require("nvim-treesitter-textobjects.move")
  local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
  local map = vim.keymap.set

  -- Select (visual + operator-pending): e.g. `vif`, `dac`
  local selects = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
  }
  for lhs, obj in pairs(selects) do
    map({ "x", "o" }, lhs, function()
      select.select_textobject(obj, "textobjects")
    end, { desc = "TS select " .. obj })
  end

  -- Swap the parameter under the cursor with the next/previous one
  map("n", "<leader>rx", function()
    swap.swap_next("@parameter.inner")
  end, { desc = "Swap parameter next" })
  map("n", "<leader>rX", function()
    swap.swap_previous("@parameter.inner")
  end, { desc = "Swap parameter previous" })

  -- Movement: ]m/[m = function, ]]/[[ = class; capital = end of node
  local moves = {
    { "]m", "goto_next_start",     "@function.outer", "Next function start" },
    { "]]", "goto_next_start",     "@class.outer",    "Next class start" },
    { "]M", "goto_next_end",       "@function.outer", "Next function end" },
    { "][", "goto_next_end",       "@class.outer",    "Next class end" },
    { "[m", "goto_previous_start", "@function.outer", "Previous function start" },
    { "[[", "goto_previous_start", "@class.outer",    "Previous class start" },
    { "[M", "goto_previous_end",   "@function.outer", "Previous function end" },
    { "[]", "goto_previous_end",   "@class.outer",    "Previous class end" },
  }
  for _, spec in ipairs(moves) do
    local lhs, fn, obj, desc = spec[1], spec[2], spec[3], spec[4]
    map({ "n", "x", "o" }, lhs, function()
      move[fn](obj, "textobjects")
    end, { desc = desc })
  end

  -- Repeat the last textobject move with ; and , (these also keep repeating
  -- the builtin f/F/t/T motions).
  map({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
  map({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
end

function M.setup()
  require("nvim-treesitter").setup()

  -- Keep parsers installed/updated (async; a no-op for already-present ones).
  require("nvim-treesitter").install(ensure_installed)

  -- The `main`-branch rewrite removed the module system. Highlighting, folding
  -- and indentation now come from Neovim's built-in treesitter runtime, wired
  -- up per buffer once a parser is available. (The global folding default lives
  -- in after/plugin/defaults.lua; `vim.treesitter.foldexpr()` safely returns 0
  -- for buffers without a parser.)
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true }),
    callback = function(args)
      -- start() errors when no parser exists for the filetype; pcall guards it.
      if pcall(vim.treesitter.start, args.buf) then
        -- Experimental on `main`; drop this line if indentation misbehaves.
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  setup_textobjects()
end

return M
