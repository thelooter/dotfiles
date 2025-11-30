-- Get Neovim version for compatibility
local has_0_7 = vim.fn.has("nvim-0.7") == 1
local has_0_10 = vim.fn.has("nvim-0.10") == 1

-- Helper to get correct highlight function name
local function get_highlight_cmd()
  if has_0_10 then
    return "vim.hl.on_yank()"
  else
    return "vim.highlight.on_yank()"
  end
end

-- Setup lazy-lock.json sync (with debug output)
local function setup_lazy_sync()
  local events = { "LazySync", "LazyUpdate", "LazyDone" }

  for _, event in ipairs(events) do
    vim.api.nvim_create_autocmd("User", {
      pattern = event,
      once = false,
      callback = function()
        print("DEBUG: Lazy event triggered: " .. event)

        -- Verify lockfile exists
        local lockfile = vim.fn.expand("~/.config/nvim-personal/lazy-lock.json")
        if vim.fn.filereadable(lockfile) == 0 then
          vim.notify("ERROR: Lockfile not found: " .. lockfile, vim.log.levels.ERROR)
          return
        end
        print("DEBUG: Found lockfile: " .. lockfile)

        -- Re-add to chezmoi
        local cmd = "chezmoi re-add " .. vim.fn.shellescape(lockfile)
        print("DEBUG: Running: " .. cmd)

        local result = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          vim.notify("chezmoi failed: " .. result, vim.log.levels.ERROR)
          return
        end
        print("DEBUG: chezmoi re-add succeeded")

        -- Commit to git
        local commit_msg = string.format("chore(nvim): update lazy-lock.json - %s", os.date("%Y-%m-%d %H:%M:%S"))
        local git_cmd = string.format(
          'cd ~/.local/share/chezmoi && git add dot_config/nvim-personal/lazy-lock.json && git commit -m "%s"',
          commit_msg:gsub('"', '\\"')
        )
        print("DEBUG: Running git commit...")

        local git_result = vim.fn.system(git_cmd)
        if vim.v.shell_error == 0 then
          vim.notify("✓ Updated lazy-lock.json in dotfiles", vim.log.levels.INFO)
        else
          vim.notify("Git commit failed: " .. git_result, vim.log.levels.WARN)
        end
      end,
    })
  end
end

-- Main autocmd setup
if not has_0_7 then
  -- Pre-0.7: Legacy Vimscript
  local cmd = vim.cmd

  cmd [[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
  ]]

  cmd [[
    augroup CursorLine
      autocmd!
      autocmd InsertLeave,WinEnter * set cursorline
      autocmd InsertEnter,WinLeave * set nocursorline
    augroup end
  ]]

  cmd [[
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
  ]]

  cmd "au FocusGained * :checktime"

  cmd [[autocmd FileType help,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>]]
  cmd [[autocmd FileType man nnoremap <buffer><silent> q :quit<CR>]]

  cmd [[autocmd BufEnter * set formatoptions-=cro]]
else
  -- 0.7+: Modern Lua API
  local api = vim.api
  local highlight_cmd = get_highlight_cmd()

  local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
  api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      loadstring(highlight_cmd)()
    end,
    group = yankGrp,
  })

  local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
  api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
  })
  api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    pattern = "*",
    command = "set nocursorline",
    group = cursorGrp,
  })

  api.nvim_create_autocmd("BufReadPost", {
    command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
  })

  api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

  api.nvim_create_autocmd("FileType", {
    pattern = { "help", "startuptime", "qf", "lspinfo" },
    command = [[nnoremap <buffer><silent> q :close<CR>]],
  })
  api.nvim_create_autocmd("FileType", {
    pattern = "man",
    command = [[nnoremap <buffer><silent> q :quit<CR>]],
  })

  api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

  -- Add lazy-lock sync for 0.7+
  setup_lazy_sync()
end
