-- Module table for exporting the setup function
local M = {}

-- Load the which-key plugin for displaying keybindings
local whichkey = require("which-key")

-- Configuration for which-key UI appearance
local conf = {
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
  },
}

-- Default options for normal mode keymaps
local opts = {
  mode = "n",    -- Normal mode
  prefix = "<leader>",
  buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

-- Default options for visual mode keymaps
local v_opts = {
  mode = "v",    -- Visual mode
  prefix = "<leader>",
  buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}


-- Sets up all normal mode keybindings using the new which-key.add() syntax
-- These are global mappings available in normal mode with <leader> prefix
local function normal_keymap()
  local keymaps_f = nil -- File search
  local keymaps_p = nil -- Project search

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
      o = { "<cmd>Outline<Cr>", "Open Outline" },
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
      w = { "<cmd>lua require('utils.session').list_sessions()<cr>", "Restore Workspace" },
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
      l = { "<cmd>LazyGit<CR>", "Open LazyGit" },
    },

    s = {
      name = "Spectre",
      S = { "<cmd>lua require('spectre').toggle()<CR>", "Toggle Spectre" },
      w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
      f = { "<cmd>lua require('spectre').open_file_search({select_word=true})", "Search current file" },
    },

    t = {
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
      A = { "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", "Run All" },
    },

    m = {
      name = "ToggleTerm",
      f = { "<cmd>ToggleTerm direction=float<cr>", "Toggle" },
      h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Toggle Horizontal" },
      v = { "<cmd>ToggleTerm direction=vertical size=80<cr>", "Toggle Vertical" },
    },
  }

  -- New which-key.add() syntax: array of mapping specs
  -- Each entry is either:
  --   {"<leader>key", "<command>", desc = "Description"} for a mapping
  --   {"<leader>key", group = "Group Name"} for a submenu
  local entries = {
    {"<leader>w", "<cmd>update!<CR>", desc = "Save"},
    {"<leader>q", "<cmd>q!<CR>", desc = "Quit"},

    {"<leader>b", group = "Buffer"},
    {"<leader>bc", "<Cmd>bd!<Cr>", desc = "Close Buffer"},
    {"<leader>bD", "<Cmd>%bd|e#|bd#<Cr>", desc = "Delete All Buffers"},

    {"<leader>c", group = "Code"},
    {"<leader>cg", "<cmd>Neogen func <cr>", desc = "Function Doc"},
    {"<leader>cG", "<cmd>Neogen class <cr>", desc = "Class Doc"},
    {"<leader>cd", "<cmd>DogeGenerate<Cr>", desc = "Generate Doc"},
    {"<leader>co", "<cmd>Outline<Cr>", desc = "Open Outline"},

    {"<leader>o", group = "DevDocs"},
    {"<leader>oo", "<cmd>DevdocsOpen<cr>", desc = "Open"},

    {"<leader>f", group = "Find"},
    {"<leader>ff", "<cmd>lua require('utils.finder').find_files()<cr>", desc = "Files"},
    {"<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers"},
    {"<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Old Files"},
    {"<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep"},
    {"<leader>fc", "<cmd>FzfLua commands<cr>", desc = "Commands"},
    {"<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Explorer"},
    {"<leader>fi", "<cmd>Telescope import<cr>", desc = "Import"},

    {"<leader>p", group = "Project"},
    {"<leader>pp", "<cmd>lua require'telescope'.extensions.project.project{}<cr>", desc = "List"},
    {"<leader>ps", "<cmd>Telescope repo list<cr>", desc = "Search"},

    {"<leader>D", group = "Database"},
    {"<leader>Du", "<Cmd>DBUIToggle<Cr>", desc = "Toggle UI"},
    {"<leader>Df", "<Cmd>DBUIFindBuffer<Cr>", desc = "Find buffer"},
    {"<leader>Dr", "<Cmd>DBUIRenameBuffer<Cr>", desc = "Rename buffer"},
    {"<leader>Dq", "<Cmd>DBUILastQueryInfo<Cr>", desc = "Last query info"},

    {"<leader>z", group = "Packer"},
    {"<leader>zc", "<cmd>PackerCompile<cr>", desc = "Compile"},
    {"<leader>zi", "<cmd>PackerInstall<cr>", desc = "Install"},
    {"<leader>zp", "<cmd>PackerProfile<cr>", desc = "Profile"},
    {"<leader>zs", "<cmd>PackerSync<cr>", desc = "Sync"},
    {"<leader>zS", "<cmd>PackerStatus<cr>", desc = "Status"},
    {"<leader>zu", "<cmd>PackerUpdate<cr>", desc = "Update"},
    {"<leader>zr", "<cmd>Telescope reloader<cr>", desc = "Reload Module"},
    {"<leader>zx", "<cmd> %:p:h:<cr>", desc = "Change Directory"},
    {"<leader>ze", "!!SHELL<CR>", desc = "Execute Line"},
    {"<leader>zW", "<cmd>lua require('utils.session').toggle_session()<cr>", desc = "Toggle Workspace Saving"},
    {"<leader>zw", "<cmd>lua require('utils.session').list_sessions()<cr>", desc = "Restore Workspace"},

    {"<leader>v", group = "Vimspector"},
    {"<leader>vG", "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>", desc = "Generate Debug Profile"},
    {"<leader>vI", "<cmd>VimspectorInstall<cr>", desc = "Install"},
    {"<leader>vU", "<cmd>VimspectorUpdate<cr>", desc = "Update"},
    {"<leader>vR", "<cmd>call vimspector#RunToCursor()<cr>", desc = "Run to Cursor"},
    {"<leader>vc", "<cmd>call vimspector#Continue()<cr>", desc = "Continue"},
    {"<leader>vi", "<cmd>call vimspector#StepInto()<cr>", desc = "Step Into"},
    {"<leader>vo", "<cmd>call vimspector#StepOver()<cr>", desc = "Step Over"},
    {"<leader>vs", "<cmd>call vimspector#Launch()<cr>", desc = "Start"},
    {"<leader>vt", "<cmd>call vimspector#ToggleBreakpoint()<cr>", desc = "Toggle Breakpoint"},
    {"<leader>vu", "<cmd>call vimspector#StepOut()<cr>", desc = "Step Out"},
    {"<leader>vS", "<cmd>call vimspector#Stop()<cr>", desc = "Stop"},
    {"<leader>vr", "<cmd>call vimspector#Restart()<cr>", desc = "Restart"},
    {"<leader>vx", "<cmd>VimspectorReset<cr>", desc = "Reset"},
    {"<leader>vH", "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", desc = "Toggle HUMAN mode"},

    {"<leader>g", group = "Git"},
    {"<leader>gl", "<cmd>LazyGit<CR>", desc = "Open LazyGit"},

    {"<leader>s", group = "Spectre"},
    {"<leader>sS", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre"},
    {"<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search current word"},
    {"<leader>sf", "<cmd>lua require('spectre').open_file_search({select_word=true})", desc = "Search current file"},

    {"<leader>t", group = "Neotest"},
    {"<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach"},
    {"<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run File"},
    {"<leader>tF", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File"},
    {"<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run Last"},
    {"<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", desc = "Debug Last"},
    {"<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run Nearest"},
    {"<leader>tN", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest"},
    {"<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Output"},
    {"<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop"},
    {"<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Summary"},
    {"<leader>tA", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = "Run All"},

    {"<leader>m", group = "ToggleTerm"},
    {"<leader>mf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle"},
    {"<leader>mh", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle Horizontal"},
    {"<leader>mv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Toggle Vertical"},
  }

  -- Register all normal mode keybindings with which-key
  whichkey.add(entries, opts)
end

-- Sets up visual mode keybindings for operations on selected text
-- These mappings are only active when text is visually selected
local function visual_keymap()

  -- Visual mode mappings using the same array syntax as normal_keymap
  whichkey.add({
    -- Spectre: search and replace across files
    {"<leader>s", group="Spectre"},
    {"<leader>sw","<esc><cmd>lua require('spectre').open_visual()<CR>", desc="Search current work"},
    -- Refactoring: code transformation operations on selected text
    {"<leader>r",group="Refactor"},
    {"<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], desc="Extract function"},
    {"<leader>rf",[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function to File')<CR>]], desc="Extract Function to File"},
    {"<leader>rv",[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], desc="Extract Variable" },
    {"<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], desc="Inline Variable" },
    {"<leader>rr", [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], desc="Refactor" },
    {"<leader>rV", [[ <Esc><Cmd>lua require('refactoring').debug.print_var({})<CR>]], desc="Debug Print Var" },
  },v_opts)
end

-- Sets up filetype-specific keybindings that vary based on the current buffer's language
-- Uses an autocommand to register mappings whenever a new filetype is detected
local function code_keymap()
  -- Register autocommand that runs CodeRunner() on every FileType event
  vim.cmd("autocmd FileType * lua CodeRunner()")

  -- Inner function that gets called for each buffer to set up language-specific keymaps
  function CodeRunner()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Get the filetype of the current buffer (e.g., "python", "lua", "java")
    local ft = vim.api.nvim_get_option_value("filetype", {
      buf = bufnr,
    })
    -- Arrays to hold normal and visual mode keybinding entries
    local entries_n = {}
    local entries_v = {}

    -- Options specific to this buffer (note: buffer = bufnr makes these buffer-local)
    local opts_n = { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
    local opts_v = { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }

    -- Define keybindings based on the detected filetype
    -- Each block sets up language-specific commands under <leader>c
    if ft == "python" then
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>cr", "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", desc = "Run"},
        {"<leader>cm", "<cmd>TermExec cmd='nodemon -e py %'<cr>", desc = "Monitor"},
      }
    elseif ft == "lua" then
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>cr", "<cmd>luafile %<cr>", desc = "Run"},
      }
    elseif ft == "rust" then
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>cr", "<cmd>Cargo run<cr>", desc = "Run"},
      }
    elseif ft == "go" then
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>cr", "<cmd>GoRun<cr>", desc = "Run"},
      }
    elseif ft == "typescript" or ft == "typescriptreact" then
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>co", "<cmd>TSLspOrganize<cr>", desc = "Organize"},
        {"<leader>cr", "<cmd>TSLspRenameFile<cr>", desc = "Rename File"},
        {"<leader>ci", "<cmd>TSLspImportAll<cr>", desc = "Import All"},
        {"<leader>ct", "<cmd>lua require('utils.test').javascript_runner()<cr>", desc = "Choose Test Runner"},
      }
    elseif ft == "java" then
      -- Java has both normal and visual mode mappings for refactoring
      entries_n = {
        {"<leader>c", group = "Code"},
        {"<leader>co", "<cmd>lua require'jdtls'.organize_imports()<cr>", desc = "Organize Imports"},
        {"<leader>cv", "<cmd>lua require('jdtls').extract_variable()<cr>", desc = "Extract Variable"},
        {"<leader>cc", "<cmd>lua require('jdtls').extract_constant()<cr>", desc = "Extract Constant"},
        {"<leader>ct", "<cmd>lua require('jdtls').test_class()<cr>", desc = "Test Class"},
        {"<leader>cn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", desc = "Test Nearest Method"},
      }
      -- Visual mode mappings for Java allow refactoring selected code
      entries_v = {
        {"<leader>c", group = "Code"},
        {"<leader>cv", "<cmd>lua require('jdtls').extract_variable(true)<cr>", desc = "Extract Variable"},
        {"<leader>cc", "<cmd>lua require('jdtls').extract_constant(true)<cr>", desc = "Extract Constant"},
        {"<leader>cm", "<cmd>lua require('jdtls').extract_method(true)<cr>", desc = "Extract Method"},
        {"<leader>ct", "<cmd>lua require('jdtls').test_class()<cr>", desc = "Test Class"},
        {"<leader>cn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", desc = "Test Nearest Method"},
      }
    end

    -- Register normal mode keybindings if any were defined for this filetype
    if #entries_n > 0 then
      whichkey.add(entries_n, opts_n)
    end

    -- Register visual mode keybindings if any were defined for this filetype
    if #entries_v > 0 then
      whichkey.add(entries_v, opts_v)
    end
  end
end

-- Main setup function called from your config to initialize all keybindings
function M.setup()
  -- Initialize all three keymap categories
  normal_keymap()  -- Global normal mode bindings
  visual_keymap()  -- Global visual mode bindings
  code_keymap()    -- Filetype-specific bindings (set up via autocommand)
end

-- Export the module
return M
