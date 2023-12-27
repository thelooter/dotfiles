local M = {}

function M.setup()
  local fn = vim.fn
  local lazypath = fn.stdpath "data" .. "/lazy/lazy.nvim"
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
    { "nvim-lua/plenary.nvim",  module = "plenary" },

    -- Notification
    {
      "rcarriga/nvim-notify",
      event = "VimEnter",
      config = function()
        vim.notify = require "notify"
      end,
    },

    -- Colorscheme
    {
      "catppuccin/nvim",
      config = function()
        require("catppuccin").setup({
          flavour = "frappe",
          integrations = {
            mason = true,
            neotree = true,
            noice = true,
            symbols_outline = true,
            lsp_trouble = true,
            which_key = true,
            lsp_saga = true,
            navic = {
              enabled = true,
              custom_bg = "NONE"
            },
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
        })

        vim.cmd "colorscheme catppuccin"
      end
    },

    -- Startup screen
    {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    },


    -- WhichKey
    {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
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
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    },

    -- Better Comment
    {
      "numToStr/Comment.nvim",
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("Comment").setup {}
      end,
    },

    -- Better surround
    { "tpope/vim-surround",     event = "InsertEnter" },

    -- Motions
    { "andymass/vim-matchup",   event = "CursorMoved" },
    { "wellle/targets.vim",     event = "CursorMoved" },
    { "unblevable/quick-scope", event = "CursorMoved" },
    { "chaoren/vim-wordmotion", opt = true,           fn = { "<Plug>WordMotion_w" } },

    -- Markdown
    {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
      dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
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
      }
    },
    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      make = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("config.telescope").setup()
      end,
      cmd = { "Telescope" },
      module = "telescope",
      keys = { "<leader>f", "<leader>p" },
      dependencies = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
          dependencies = {
            "kkharji/sqlite.lua"
          }
        },
        "nvim-telescope/telescope-file-browser.nvim"
      },
    },
    -- nvim-tree
    {
      "kyazdani42/nvim-tree.lua",
      dependencies = "nvim-web-devicons",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      module = "nvim-tree",
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
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    },

    -- Auto tag
    {
      "windwp/nvim-ts-autotag",
      dependencies = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
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
        "folke/neodev.nvim",
        "RRethy/vim-illuminate",
        "nvimtools/none-ls.nvim",
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
    },

    {
      "nvimtools/none-ls.nvim"
    },


    -- trouble.nvim
    {
      "folke/trouble.nvim",
      event = "BufReadPre",
      dependencies = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup {
          use_diagnostic_signs = true,
        }
      end,
    },

    -- lspsaga.nvim
    {
      "tami5/lspsaga.nvim",
      event = "VimEnter",
      cmd = { "Lspsaga" },
      config = function()
        require("lspsaga").setup {}
      end,
    },

    -- Rust
    {
      "simrat39/rust-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
      module = "rust-tools",
      ft = { "rust" },
      config = function()
        require("rust-tools").setup {}
      end,
    },

    -- Go
    {
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("go").setup()
      end,
    },

    -- Debugging
    {
      "mfussenegger/nvim-dap",
      event = "BufReadPre",
      module = { "dap" },
      dependencies = {
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
    },

    {
      "rcarriga/vim-ultest",
      dependencies = { "vim-test/vim-test" },
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
      end
    },

    {
      "ThePrimeagen/refactoring.nvim",
      module = {
        "refactoring",
        "telescope"
      },
      keys = {
        [[<leader>r]]
      },
      dependencies = {
        "telescope.nvim"
      },
      config = function()
        require("config.refactoring").setup()
      end
    },

    {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
    },

    {
      "kkoomen/vim-doge",
      run = ":call doge#install()",
      config = function()
        require("config.doge").setup()
      end,
      cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    },

    {
      "potamides/pantran.nvim"
    },

    {
      "mfussenegger/nvim-jdtls",
      ft = { "java" }
    },

    {
      "diepm/vim-rest-console",
      ft = { "rest" }
    },

    {
      "NTBBloodbath/rest.nvim",
      config = function()
        require("rest-nvim").setup {}
        vim.keymap.set("n", "<C-j>", "<Plug>RestNvim", { noremap = true, silent = true })
      end,
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
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
    },

    {
      "SmiteshP/nvim-navic",
      dependencies = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup {
          highlight = true,
          click = true
        }
      end,
    },

    { 'krivahtoo/silicon.nvim',  build = './install.sh' },

    {
      "kdheepak/lazygit.nvim",
      -- dependencies for floating window border decoration
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },


    {
      "anuvyklack/hydra.nvim",
      config = function()
        require("config.hydra").setup()
      end,
      dependencies = "anuvyklack/keymap-layer.nvim",
      module = { "hydra" },
      event = { "BufReadPre" },
    },


    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require("symbols-outline").setup()
      end
    },

    {
      "andweeb/presence.nvim",
      config = function()
        require("config.presence").setup()
      end
    },

    {
      "akinsho/toggleterm.nvim",
      version = '*',
      config = function()
        require("toggleterm").setup()
      end
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
      cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    },

    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("config.copilot").setup()
      end,
    },

    {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup()
      end
    },

    { "onsails/lspkind.nvim" },

    { "folke/todo-comments.nvim" },

    {
      "piersolenski/telescope-import.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
    },

    {
      "luckasRanarison/nvim-devdocs",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("nvim-devdocs").setup()
      end
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
        "3rd/image.nvim",              -- dependencies image support in preview window: See `# Preview Mode` for more information
      },
      config = function()
        require("neo-tree").setup {
          filesystem = {
            filtered_items = {
              visible = true,
              hide_dotfiles = false,
              hide_gitignore = false,
              hide_by_name = {
                '.git',
                '.DS_Store',
                'thumbs.db',
              },
            }
          }
        }
      end,
    },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    {
      "ibhagwan/fzf-lua",
      -- dependencies for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is dependencies for customization
        require("fzf-lua").setup({})
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      event = {
        "BufReadPre",
        "BufNewFile"
      }
    },

    {
      'pwntester/octo.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require "octo".setup()
      end
    }

  })
end

return M
