local M = {}


local whichkey = require "which-key"

local conf = {
  window = {
    border = "single",   -- none, single, double, shadow
    position = "bottom", -- bottom, top
  },
}

local opts = {
  mode = "n",     -- Normal mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
  mode = "v",     -- Visual mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}


local function normal_keymap()
  local keymaps_f = nil -- File search
  local keymaps_p = nil -- Project search

  if PLUGINS.telescope.enabled then
    keymaps_f = {
      name = "Find",
      f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
      d = { "<cmd>lua require('utils.finder').find_dotfiles()<cr>", "Dotfiles" },
      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
      h = { "<cmd>Telescope help_tags<cr>", "Help" },
      o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
      g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
      c = { "<cmd>Telescope commands<cr>", "Commands" },
      r = { "<cmd>Telescope file_browser<cr>", "Browser" },
      w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
      i = { "<cmd>Telescope import<cr>", "Import" },
      e = { "<cmd>Neotree toggle<cr>", "Explorer" },
    }

    keymaps_p = {
      name = "Project",
      p = { "<cmd>lua require'telescope'.extensions.project.project{}<cr>", "List" },
      s = { "<cmd>Telescope repo list<cr>", "Search" },
    }
  end

  if PLUGINS.fzf_lua.enabled then
    keymaps_f = {
      name = "Find",
      f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
      b = { "<cmd>FzfLua buffers<cr>", "Buffers" },
      o = { "<cmd>FzfLua oldfiles<cr>", "Old Files" },
      g = { "<cmd>FzfLua live_grep<cr>", "Live Grep" },
      c = { "<cmd>FzfLua commands<cr>", "Commands" },
      e = { "<cmd>Neotree toggle<cr>", "Explorer" },
      i = { "<cmd>Telescope import<cr>", "Import" },
    }
  end



  local mappings = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close Buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete All Buffers" },
    },

    c = {
      name = "Code",
      g = { "<cmd>Neogen func <cr>", "Function Doc" },
      G = { "<cmd>Neogen class <cr>", "Class Doc" },
      d = { "<cmd>DogeGenerate<Cr>", "Generate Doc" },
      o = { "<cmd>SymbolsOutline<Cr>", "Open SymbolsOutline" }
    },

    o = {
      name = "DevDocs",
      o = { "<cmd>DevdocsOpen<cr>", "Open" },
    },

    f = keymaps_f,
    p = keymaps_p,

    D = {
      name = "Database",
      u = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
      f = { "<Cmd>DBUIFindBuffer<Cr>", "Find buffer" },
      r = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
      q = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
    },

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      p = { "<cmd>PackerProfile<cr>", "Profile" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
      r = { "<cmd>Telescope reloader<cr>", "Reload Module" },
      x = { "<cmd> %:p:h:<cr>", "Change Directory" },
      e = { "!!SHELL<CR>", "Execute Line" },
      W = { "<cmd>lua require('utils.session').toggle_session()<cr>", "Toggle Workspace Saving" },
      w = { "<cmd>lua require('utils.session').list_sessions()<cr>", "Restore Workspace" }
    },

    v = {
      name = "Vimspector",
      G = { "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>", "Generate Debug Profile" },
      I = { "<cmd>VimspectorInstall<cr>", "Install" },
      U = { "<cmd>VimspectorUpdate<cr>", "Update" },
      R = { "<cmd>call vimspector#RunToCursor()<cr>", "Run to Cursor" },
      c = { "<cmd>call vimspector#Continue()<cr>", "Continue" },
      i = { "<cmd>call vimspector#StepInto()<cr>", "Step Into" },
      o = { "<cmd>call vimspector#StepOver()<cr>", "Step Over" },
      s = { "<cmd>call vimspector#Launch()<cr>", "Start" },
      t = { "<cmd>call vimspector#ToggleBreakpoint()<cr>", "Toggle Breakpoint" },
      u = { "<cmd>call vimspector#StepOut()<cr>", "Step Out" },
      S = { "<cmd>call vimspector#Stop()<cr>", "Stop" },
      r = { "<cmd>call vimspector#Restart()<cr>", "Restart" },
      x = { "<cmd>VimspectorReset<cr>", "Reset" },
      H = { "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", "Toggle HUMAN mode" },
    },

    g = {
      name = "Git",
      l = { "<cmd>LazyGit<CR>", "Open LazyGit" }
    },

    s = {
      name = "Spectre",
      S = { "<cmd>lua require('spectre').toggle()<CR>", "Toggle Spectre" },
      w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
      f = { "<cmd>lua require('spectre').open_file_search({select_word=true})", "Search current file" }
    },

    n = {
      name = "Neotest",
      a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
      f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
      F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Debug File" },
      l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
      L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
      n = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
      N = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
      o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
      S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
      s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
    },


  }

  whichkey.register(mappings, opts)
end

local function visual_keymap()
  local keymap = {
    g = {
      name = "Git",
      y = {
        "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>",
        "Link",
      }
    },
    s = {
      name = "Spectre",
      w = { "<esc><cmd>lua require('spectre').open_visual()<CR>", "Search current work" }
    },
    r = {
      name = "Refactor",
      e    = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Extract function" },
      f    = {
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function to File')<CR>]],
        "Extract Function to File",
      },
      v    = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Extract Variable" },
      i    = { [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
      r    = { [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], "Refactor" },
      V    = { [[ <Esc><Cmd>lua require('refactoring').debug.print_var({})<CR>]], "Debug Print Var" },
    }
  }
  whichkey.register(keymap, v_opts)
end

local function code_keymap()
  vim.cmd "autocmd FileType * lua CodeRunner()"

  function CodeRunner()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local keymap = nil
    local keymap_c_v = {} -- visual key map

    if ft == "python" then
      keymap = {
        name = "Code",
        r = { "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run" },
        m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
      }
    elseif ft == "lua" then
      keymap = {
        name = "Code",
        r = { "<cmd>luafile %<cr>", "Run" }
      }
    elseif ft == "rust" then
      keymap = {
        name = "Code",
        r = { "<cmd>Cargo run<cr>", "Run" }
      }
    elseif ft == "go" then
      keymap = {
        name = "Code",
        r = { "<cmd>GoRun<cr>", "Run" },
      }
    elseif ft == "typescript" or ft == "typescriptreact" then
      keymap = {
        name = "Code",
        o = { "<cmd>TSLspOrganize<cr>", "Organize" },
        r = { "<cmd>TSLspRenameFile<cr>", "Rename File" },
        i = { "<cmd>TSLspImportAll<cr>", "Import All" },
        t = { "<cmd>lua require('utils.test').javascript_runner()<cr>", "Choose Test Runner" },
      }
    elseif ft == "java" then
      keymap = {
        name = "Code",
        o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
        v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
        c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
        t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
        n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
      }
      keymap_c_v = {
        name = "Code",
        v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
        c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
        m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
        t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
        n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
      }
    end

    if keymap ~= nil then
      local k = { c = keymap }
      local o = { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
      whichkey.register(k, o)
    end

    if next(keymap_c_v) ~= nil then
      local k = { c = keymap_c_v }
      local o = { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
      whichkey.register(k, o)
    end
  end
end

function M.setup()
  normal_keymap()
  visual_keymap()
  code_keymap()
end

return M
