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

-- Setup lazy-lock.json sync (stores hash in Neovim state store)
local function setup_lazy_sync()
  local events = { "LazySync", "LazyUpdate", "LazyDone" }

  -- Get dynamic paths based on current Neovim instance
  local config_dir = vim.fn.stdpath('config')
  local state_dir = vim.fn.stdpath('state')
  local lockfile = config_dir .. "/lazy-lock.json"
  local hash_file = state_dir .. "/chezmoi-lazy-lock-hash"

  -- Extract config name (nvim-personal) for chezmoi path
  local config_name = vim.fn.fnamemodify(config_dir, ":t")
  local chezmoi_lockfile_path = string.format("dot_config/%s/lazy-lock.json", config_name)

  local function get_file_hash(path)
    if vim.fn.filereadable(path) == 0 then
      return nil
    end
    local content = vim.fn.readfile(path)
    return vim.fn.sha256(vim.fn.join(content, '\n'))
  end

  local function load_previous_hash()
    if vim.fn.filereadable(hash_file) == 1 then
      return vim.fn.readfile(hash_file)[1]
    end
    return nil
  end

  local function save_hash(hash)
    vim.fn.writefile({hash}, hash_file)
  end

  -- Initialize hash after Lazy loads (only if not exists)
  vim.defer_fn(function()
    local current_hash = get_file_hash(lockfile)
    local previous_hash = load_previous_hash()

    if current_hash then
      if not previous_hash then
        -- First time initialization
        save_hash(current_hash)
        print("DEBUG: Initialized lockfile hash (stored in " .. hash_file .. "): " .. current_hash)
      elseif previous_hash ~= current_hash then
        -- Hash changed between sessions (e.g., manual edit)
        print("DEBUG: Warning: Lockfile changed between sessions! Old: " .. previous_hash .. ", New: " .. current_hash)
        save_hash(current_hash)
      end
      -- If hash exists and is unchanged, do nothing (no message)
    end
  end, 500)

  for _, event in ipairs(events) do
    vim.api.nvim_create_autocmd("User", {
      pattern = event,
      once = false,
      callback = function()
        -- Defer to ensure Lazy finishes writing the file
        vim.defer_fn(function()
          if vim.fn.filereadable(lockfile) == 0 then
            vim.notify("ERROR: Lockfile not found: " .. lockfile, vim.log.levels.ERROR)
            return
          end

          -- Check if file actually changed
          local current_hash = get_file_hash(lockfile)
          local previous_hash = load_previous_hash()

          if current_hash == previous_hash then
            return
          end

          print("DEBUG: Lockfile changed! Old: " .. (previous_hash or "nil") .. ", New: " .. current_hash)

          -- Re-add to chezmoi
          local cmd = "chezmoi re-add " .. vim.fn.shellescape(lockfile)
          print("DEBUG: Running: " .. cmd)

          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("chezmoi failed: " .. result, vim.log.levels.ERROR)
            return
          end

          -- Commit ONLY the lockfile, preserving other staged files
          local commit_msg = string.format("chore(nvim): update lazy-lock.json - %s", os.date("%Y-%m-%d %H:%M:%S"))
          local git_cmd = string.format(
            'cd ~/.local/share/chezmoi && ' ..
            'STAGED=$(git diff --cached --name-only); ' ..
            'if [ -n "$STAGED" ]; then ' ..
            '  echo "Temporarily unstaging other files..."; ' ..
            '  git reset HEAD; ' ..
            'fi; ' ..
            'git add %s && ' ..
            'git commit -m "%s" && ' ..
            'if [ -n "$STAGED" ]; then ' ..
            '  echo "Restoring previously staged files..."; ' ..
            '  git add $STAGED; ' ..
            'fi',
            chezmoi_lockfile_path,
            commit_msg:gsub('"', '\\"')
)

          local git_result = vim.fn.system(git_cmd)
          if vim.v.shell_error == 0 then
            -- Save the new hash only on successful commit
            save_hash(current_hash)
            vim.notify("✓ Updated lazy-lock.json in dotfiles", vim.log.levels.INFO)
          else
            vim.notify("Git commit failed: " .. git_result, vim.log.levels.WARN)
          end
        end, 100) -- 100ms delay for file I/O
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
