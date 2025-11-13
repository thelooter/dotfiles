local M = {}

function M.setup()
  local fn = vim.fn
  local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)

  -- Plugins
  require("lazy").setup({
    -- Load only when require
    { "nvim-lua/plenary.nvim" },

    -- Notification
    {
      "rcarriga/nvim-notify",
      event = "VimEnter",
      config = function()
        vim.notify = require("notify")
      end,
    },

    -- Colorscheme
    {
      "catppuccin/nvim",
      config = function()
        require("config.catppuccin").setup()
        vim.cmd("colorscheme catppuccin")
      end,
    },

    -- Startup screen
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      config = function()
        require("dashboard").setup({
          hide = {
            statusline = false, -- hide statusline default is true
            tabline = false,    -- hide the tabline
            winbar = false,     -- hide winbar
          },
        })
      end,
      dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },

    -- WhichKey
    {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.which-key-new").setup()
      end,
    },

    -- IndentLine
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    },

    -- Better icons
    {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({ default = true })
      end,
    },

    -- Better Comment
    {
      "numToStr/Comment.nvim",
    },

    -- Better surround
    { "tpope/vim-surround",     event = "InsertEnter" },

    -- Motions
    { "andymass/vim-matchup",   event = "CursorMoved" },
    { "wellle/targets.vim",     event = "CursorMoved" },
    { "unblevable/quick-scope", event = "CursorMoved" },
    {
      "chaoren/vim-wordmotion",
      fn = { "<Plug>WordMotion_w" },
    },

    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("config.lualine").setup()
      end,
      dependencies = {
        "nvim-web-devicons",
        "nvim-treesitter",
      },
    },
    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      branch = "main",
      build = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      dependencies = {
        -- { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("config.telescope").setup()
      end,
      cmd = { "Telescope" },
      keys = { "<leader>f", "<leader>p" },
      dependencies = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build =
          "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
        "cljoly/telescope-repo.nvim",
        {
          "nvim-telescope/telescope-frecency.nvim",
          dependencies = {
            "kkharji/sqlite.lua",
          },
        },
        "nvim-telescope/telescope-file-browser.nvim",
      },
    },
    -- nvim-tree
    {
      "kyazdani42/nvim-tree.lua",
      dependencies = "nvim-web-devicons",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("config.nvimtree").setup()
      end,
    },

    -- Buffer line
    {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      dependencies = "nvim-web-devicons",
      config = function()
        require("config.bufferline").setup()
      end,
    },

    {
      "folke/noice.nvim",
      config = function()
        require("config.noice").setup()
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    },

    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        require("config.cmp").setup()
      end,
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      },
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = "friendly-snippets",
      config = function()
        require("config.snip").setup()
      end,
    },

    -- Auto pairs
    {
      "windwp/nvim-autopairs",
      dependencies = "nvim-treesitter",
      config = function()
        require("config.autopairs").setup()
      end,
    },

    -- Auto tag
    {
      "windwp/nvim-ts-autotag",
      dependencies = "nvim-treesitter",
    },

    -- End wise
    {
      "RRethy/nvim-treesitter-endwise",
      dependencies = "nvim-treesitter",
      event = "InsertEnter",
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      config = function()
        require("config.lsp").setup()
      end,
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "RRethy/vim-illuminate",
        "nvimtools/none-ls.nvim",
        {
          "j-hui/fidget.nvim",
          config = function()
            require("config.fidget").setup()
          end,
        },
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        --{
        --  "simrat39/inlay-hints.nvim",
        --  config = function()
        --    require("inlay-hints").setup()
        --  end,
        --},
      },
    },

    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
      },
    },

    -- trouble.nvim
    {
      "folke/trouble.nvim",
      event = "BufReadPre",
      dependencies = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup({
          use_diagnostic_signs = true,
        })
      end,
    },

    -- lspsaga.nvim
    {
      "nvimdev/lspsaga.nvim",
      event = "VimEnter",
      cmd = { "Lspsaga" },
      config = function()
        require("lspsaga").setup({})
      end,
    },

    -- Rust (removed — rust-tools config caused startup issues)

    -- Go
    {
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("go").setup({
          lsp_cfg = true,
        })
      end,
    },

    -- Debugging1
    {
      "mfussenegger/nvim-dap",
      event = "BufReadPre",
      dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go" },
        { "jbyuki/one-small-step-for-vimkind" },
      },
      config = function()
        require("config.dap").setup()
      end,
    },

    -- vimspector
    {
      "puremourning/vimspector",
      cmd = { "VimspectorInstall", "VimspectorUpdate" },
      fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
      config = function()
        require("config.vimspector").setup()
      end,
    },

    {
      "norcalli/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
        require("colorizer").setup()
      end,
    },

    {
      "nvim-pack/nvim-spectre",
      config = function()
        require("spectre").setup()
      end,
    },

    {
      "ThePrimeagen/refactoring.nvim",
      keys = {
        [[<leader>r]],
      },
      dependencies = {
        "telescope.nvim",
      },
      config = function()
        require("config.refactoring").setup()
      end,
    },

    {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
    },

    {
      "kkoomen/vim-doge",
      build = ":call doge#install()",
      config = function()
        require("config.doge").setup()
      end,
      cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    },

    {
      "potamides/pantran.nvim",
    },

    {
      "mfussenegger/nvim-jdtls",
      ft = { "java" },
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary",
        "fredrikaverpil/neotest-golang",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-vim-test",
        "andy-bell101/neotest-java",
      },
      config = function()
        require("config.neotest").setup()
      end,
    },

    {
      "SmiteshP/nvim-navic",
      dependencies = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup({
          highlight = true,
          click = true,
        })
      end,
    },

    { "krivahtoo/silicon.nvim", build = "./install.sh" },

    {
      "kdheepak/lazygit.nvim",
      -- dependencies for floating window border decoration
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },

    {
      "nvimtools/hydra.nvim",
      config = function()
        require("config.hydra").setup()
      end,
      dependencies = "anuvyklack/keymap-layer.nvim",
      event = { "BufReadPre" },
    },

    {
      "hedyhli/outline.nvim",
      config = function()
        require("config.outline").setup()
      end,
    },

    {
      "andweeb/presence.nvim",
      config = function()
        require("config.presence").setup()
      end,
    },

    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          direction = "float",
        })
      end,
    },

    -- Database
    {
      "tpope/vim-dadbod",
      dependencies = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
      },
      config = function()
        require("config.dadbod").setup()
      end,
      cmd = {
        "DBUIToggle",
        "DBUI",
        "DBUIAddConnection",
        "DBUIFindBuffer",
        "DBUIRenameBuffer",
        "DBUILastQueryInfo",
      },
    },

    { "onsails/lspkind.nvim" },

    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("todo-comments").setup({})
      end,
    },

    {
      "piersolenski/telescope-import.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
    },

    {
      "someone-stole-my-name/yaml-companion.nvim",
      dependencies = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
      },
    },

    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
          filesystem = {
            filtered_items = {
              visible = true,
              hide_dotfiles = false,
              hide_gitignore = false,
              hide_by_name = {
                ".git",
                ".DS_Store",
                "thumbs.db",
              },
            },
          },
        })
      end,
    },
    { "hrsh7th/cmp-nvim-lsp",     lazy = true },
    {
      "ibhagwan/fzf-lua",
      -- dependencies for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is dependencies for customization
        require("fzf-lua").setup({})
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
    },

    {
      "pwntester/octo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("octo").setup()
      end,
    },
    {
      "ray-x/guihua.lua",
      build = "cd lua/fzy && make",
    },
    {
      "Wansmer/symbol-usage.nvim",
      event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
      config = function()
        require("config.symbol-usage").setup()
      end,
    },
    {
      "aznhe21/actions-preview.nvim",
      config = function()
        require("config.actions-preview").setup()
      end,
      keys = {
        {
          "ga",
          function()
            require("actions-preview").code_actions()
          end,
          desc = "Code Action Preview",
          mode = { "n", "v" },
        },
      },
    },
    {
      "Dynge/gitmoji.nvim",
      dependencies = {
        "hrsh7th/nvim-cmp",
      },
      opts = {},
      ft = "gitcommit",
    },
    {
      "davidsierradz/cmp-conventionalcommits",
    },
    {
      "kawre/neotab.nvim",
      event = "InsertEnter",
    },
    { "wakatime/vim-wakatime",    lazy = false },
    { "mfussenegger/nvim-ansible" },
    { "nvim-neotest/nvim-nio" },
    {
      "akinsho/flutter-tools.nvim",
      config = function()
        require("flutter-tools").setup({}) -- use defaults
      end,
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
      },
    },
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          "lazy.nvim",
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
      "rachartier/tiny-devicons-auto-colors.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      event = "VeryLazy",
      config = function()
        local theme_colors = require("catppuccin.palettes").get_palette("frappe")
        require("tiny-devicons-auto-colors").setup({
          colors = theme_colors,
        })
      end,
    },
    {
      "lervag/vimtex",
      lazy = false, -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end,
    },
    {
      "sopa0/telescope-makefile",
    },
    {
      "grafana/vim-alloy",
    },
    { -- This plugin
      "Zeioth/compiler.nvim",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
      opts = {},
    },
    { -- The task runner we use
      "stevearc/overseer.nvim",
      commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1,
        },
      },
    },
  })
end

return M
