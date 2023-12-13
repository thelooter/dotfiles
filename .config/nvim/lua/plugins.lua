local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },

    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    -- Performance
    use { "lewis6991/impatient.nvim" }

    -- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Notification
    use {
      "rcarriga/nvim-notify",
      event = "VimEnter",
      config = function()
        vim.notify = require "notify"
      end,
    }

    -- Colorscheme
    use {
      "catppuccin/nvim",
      config = function()
        require("catppuccin").setup({
          flavour = "frappe",
        })

        vim.cmd "colorscheme catppuccin"
      end
    }

    -- Startup screen
    use {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    }

    -- Better Netrw
    use { "tpope/vim-vinegar" }

    -- Git
    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("config.neogit").setup()
      end,
    }

    use {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      wants = "plenary.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns").setup()
      end,
    }

    use {
      "tpope/vim-fugitive",
      cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
      requires = { "tpope/vim-rhubarb" },
      -- wants = { "vim-rhubarb" },
    }

    -- WhichKey
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
      end,
    }

    -- IndentLine
    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    }

    -- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Better Comment
    use {
      "numToStr/Comment.nvim",
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("Comment").setup {}
      end,
    }

    -- Better surround
    use { "tpope/vim-surround", event = "InsertEnter" }

    -- Motions
    use { "andymass/vim-matchup", event = "CursorMoved" }
    use { "wellle/targets.vim", event = "CursorMoved" }
    use { "unblevable/quick-scope", event = "CursorMoved", disable = false }
    use { "chaoren/vim-wordmotion", opt = true, fn = { "<Plug>WordMotion_w" } }

    -- Markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
      requires = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
    }

    -- Status line
    use {
      "nvim-lualine/lualine.nvim",
      after = "nvim-treesitter",
      config = function()
        require("config.lualine").setup()
      end,
      wants = "nvim-web-devicons",
    }
    use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter",
      module = "nvim-gps",
      wants = "nvim-treesitter",
      config = function()
        require("nvim-gps").setup()
      end,
    }

    -- Treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    }

    if PLUGINS.fzf_lua.enabled then
      use {
        "ibhagwan/fzf-lua",
        event = "BufEnter",
        wants = "nvim-web-devicons",
        requires = { "junegunn/fzf", run = "./install --all" },
      }
    end

    if PLUGINS.telescope.enabled then
      use {
        "nvim-telescope/telescope.nvim",
        opt = true,
        config = function()
          require("config.telescope").setup()
        end,
        cmd = { "Telescope" },
        module = "telescope",
        keys = { "<leader>f", "<leader>p" },
        wants = {
          "plenary.nvim",
          "popup.nvim",
          "telescope-fzf-native.nvim",
          "telescope-project.nvim",
          "telescope-repo.nvim",
          "telescope-file-browser.nvim",
          "project.nvim",
          "telescope-frecency.nvim"
        },
        requires = {
          "nvim-lua/popup.nvim",
          "nvim-lua/plenary.nvim",
          { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
          "nvim-telescope/telescope-project.nvim",
          "cljoly/telescope-repo.nvim",
          {
            "ahmedkhalf/project.nvim",
            config = function()
              require("project_nvim").setup {}
            end,
          },
          {
            "nvim-telescope/telescope-frecency.nvim",
            requires = {
              "kkharji/sqlite.lua"
            }
          },
          "nvim-telescope/telescope-file-browser.nvim"
        },
      }
    end

    -- nvim-tree
    use {
      "kyazdani42/nvim-tree.lua",
      wants = "nvim-web-devicons",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      module = "nvim-tree",
      config = function()
        require("config.nvimtree").setup()
      end,
    }

    -- Buffer line
    use {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      config = function()
        require("config.bufferline").setup()
      end,
    }

    -- User interface
    -- use {
    --   "stevearc/dressing.nvim",
    --   event = "BufEnter",
    --   config = function()
    --     require("dressing").setup {
    --       input = {
    --         relative = "editor"
    --       },
    --       select = {
    --         backend = { "telescope", "fzf", "builtin" },
    --       },
    --     }
    --   end,
    --   disable = false,
    -- }

    use {
      "folke/noice.nvim",
      config = function()
        require("config.noice").setup()
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    }

    -- Completion
    use {
      "ms-jpq/coq_nvim",
      branch = "coq",
      event = "InsertEnter",
      opt = true,
      run = ":COQdeps",
      config = function()
        require("config.coq").setup()
      end,
      requires = {
        { "ms-jpq/coq.artifacts",  branch = "artifacts" },
        { "ms-jpq/coq.thirdparty", branch = "3p",       module = "coq_3p" },
      },
      disable = not PLUGINS.coq.enabled,
    }

    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-calc",
        -- "f3fora/cmp-spell",
        -- "hrsh7th/cmp-emoji",
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
          config = function()
            require("config.snip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      },
      disable = not PLUGINS.nvim_cmp.enabled,
    }

    -- Auto pairs
    use {
      "windwp/nvim-autopairs",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }

    -- Auto tag
    use {
      "windwp/nvim-ts-autotag",
      wants = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    }

    -- End wise
    use {
      "RRethy/nvim-treesitter-endwise",
      wants = "nvim-treesitter",
      event = "InsertEnter",
      disable = false,
    }

    -- LSP
    if PLUGINS.nvim_cmp.enabled then
      use {
        "neovim/nvim-lspconfig",
        opt = true,
        event = "BufReadPre",
        wants = {
          "mason.nvim",
          "mason-lspconfig.nvim",
          "mason-tool-installer.nvim",
          "cmp-nvim-lsp",
          "neodev.nvim",
          "vim-illuminate",
          "null-ls.nvim",
          "schemastore.nvim",
          "nvim-lsp-ts-utils",
          "inlay-hints.nvim",
        },
        config = function()
          require("config.lsp").setup()
        end,
        requires = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          "folke/neodev.nvim",
          "RRethy/vim-illuminate",
          "jose-elias-alvarez/null-ls.nvim",
          {
            "j-hui/fidget.nvim",
            config = function()
              require("fidget").setup {}
            end,
            tag = "legacy"
          },
          "b0o/schemastore.nvim",
          "jose-elias-alvarez/nvim-lsp-ts-utils",
          {
            "simrat39/inlay-hints.nvim",
            config = function()
              require("inlay-hints").setup()
            end,
          },
        },
      }
    end

    if PLUGINS.coq.enabled then
      use {
        "neovim/nvim-lspconfig",
        opt = true,
        event = "BufReadPre",
        wants = {
          "mason.nvim",
          "mason-lspconfig.nvim",
          "mason-tool-installer.nvim",
          "coq_nvim",
          "neodev.nvim",
          "vim-illuminate",
          "null-ls.nvim",
          "schemastore.nvim",
          "nvim-lsp-ts-utils"
        }, -- for coq.nvim
        config = function()
          require("config.lsp").setup()
        end,
        requires = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          "folke/neodev.nvim",
          "RRethy/vim-illuminate",
          "jose-elias-alvarez/null-ls.nvim",
          {
            "j-hui/fidget.nvim",
            config = function()
              require("fidget").setup {}
            end,
          },
          "b0o/schemastore.nvim",
          "jose-elias-alvarez/nvim-lsp-ts-utils",
        },
      }
    end

    -- trouble.nvim
    use {
      "folke/trouble.nvim",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup {
          use_diagnostic_signs = true,
        }
      end,
    }

    -- lspsaga.nvim
    use {
      "tami5/lspsaga.nvim",
      event = "VimEnter",
      cmd = { "Lspsaga" },
      config = function()
        require("lspsaga").setup {}
      end,
    }

    -- Rust
    use {
      "simrat39/rust-tools.nvim",
      requires = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
      module = "rust-tools",
      ft = { "rust" },
      config = function()
        require("rust-tools").setup {}
      end,
    }

    -- Go
    use {
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("go").setup()
      end,
    }

    -- Debugging
    use {
      "mfussenegger/nvim-dap",
      opt = true,
      event = "BufReadPre",
      module = { "dap" },
      wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
      requires = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go",                module = "dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
      config = function()
        require("config.dap").setup()
      end,
    }

    use {
      "rcarriga/vim-ultest",
      requires = { "vim-test/vim-test" },
      opt = true,
      keys = { "<leader>t" },
      cmd = {
        "TestNearest",
        "TestFile",
        "TestSuite",
        "TestLast",
        "TestVisit",
        "Ultest",
        "UltestNearest",
        "UltestDebug",
        "UltestLast",
        "UltestSummary",
      },
      module = "ultest",
      run = ":UpdateRemotePlugins",
      config = function()
        require("config.test").setup()
      end,
    }

    -- vimspector
    use {
      "puremourning/vimspector",
      cmd = { "VimspectorInstall", "VimspectorUpdate" },
      fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
      config = function()
        require("config.vimspector").setup()
      end,
    }

    use {
      "norcalli/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
        require("colorizer").setup()
      end,
    }

    use {
      "nvim-pack/nvim-spectre",
      config = function()
        require("spectre").setup()
      end
    }

    use {
      "ThePrimeagen/refactoring.nvim",
      module = {
        "refactoring",
        "telescope"
      },
      keys = {
        [[<leader>r]]
      },
      wants = {
        "telescope.nvim"
      },
      config = function()
        require("config.refactoring").setup()
      end
    }

    use {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
      disable = false,
    }

    use {
      "kkoomen/vim-doge",
      run = ":call doge#install()",
      config = function()
        require("config.doge").setup()
      end,
      cmd = { "DogeGenerate", "DogeCreateDocStandard" },
      disable = false,
    }

    use {
      "potamides/pantran.nvim"
    }

    use {
      "mfussenegger/nvim-jdtls",
      ft = { "java" }
    }

    use {
      "diepm/vim-rest-console",
      ft = { "rest" }
    }

    use {
      "NTBBloodbath/rest.nvim",
      config = function()
        require("rest-nvim").setup {}
        vim.keymap.set("n", "<C-j>", "<Plug>RestNvim", { noremap = true, silent = true })
      end,
    }

    use {
      "nvim-neotest/neotest",
      opt = true,
      wants = {
        "plenary.nvim",
        "nvim-treesitter",
        "FixCursorHold.nvim",
        "neotest-python",
        "neotest-plenary",
        "neotest-go",
        "neotest-jest",
        "neotest-vim-test",
        "neotest-java"
      },
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary",
        "nvim-neotest/neotest-go",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-vim-test",
        "andy-bell101/neotest-java"
      },
      module = { "neotest" },
      config = function()
        require("config.neotest").setup()
      end,
    }

    use {
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig"
    }

    use { 'krivahtoo/silicon.nvim', run = './install.sh' }

    use({
      "kdheepak/lazygit.nvim",
      -- optional for floating window border decoration
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })


    use {
      "anuvyklack/hydra.nvim",
      config = function()
        require("config.hydra").setup()
      end,
      requires = "anuvyklack/keymap-layer.nvim",
      module = { "hydra" },
      event = { "BufReadPre" },
    }


    use {
      'simrat39/symbols-outline.nvim',
      config = function()
        require("symbols-outline").setup()
      end
    }

    use {
      "andweeb/presence.nvim",
      config = function()
        require("config.presence").setup()
      end
    }

    use {
      "akinsho/toggleterm.nvim",
      tag = '*',
      config = function()
        require("toggleterm").setup()
      end
    }

    -- Database
    use {
      "tpope/vim-dadbod",
      opt = true,
      requires = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
      },
      config = function()
        require("config.dadbod").setup()
      end,
      cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    }

    use {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("config.copilot").setup()
      end,
    }

    use {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end
    }

    use { "onsails/lspkind.nvim" }

    use { "folke/todo-comments.nvim" }

    use {
      "piersolenski/telescope-import.nvim",
      requires = {
        "nvim-telescope/telescope.nvim",
      },
    }

    use {
      "luckasRanarison/nvim-devdocs",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("nvim-devdocs").setup()
      end
    }

    use {
      "someone-stole-my-name/yaml-companion.nvim",
      requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
      },
    }

    use 'fedepujol/bracketpair.nvim'

    -- Bootstrap Neovim
    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  -- Init and start packer
  packer_init()
  local packer = require "packer"

  pcall(require, "impatient")

  packer.init(conf)
  packer.startup(plugins)
end

return M
