local overrides = require("custom.configs.overrides")

local plugins = {
  {
    'neovim/nvim-lspconfig',
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
   end,
  },
  {
    'mfussenegger/nvim-dap',
    init = function ()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    'leoluz/nvim-dap-go',
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function (_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        "gopls",
        "lua-language-server",
        "bash-language-server",
        "ansible-language-server",
        "ansible-lint",
        "clangd",
        "cmake-language-server",
        "css-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "gradle-language-server",
        "graphql-language-service-cli",
        "groovy-language-server",
        "html-lsp",
        "json-lsp",
        "jdtls",
        "typescript-language-server",
        "kotlin-language-server",
        "marksman",
        "sqlls",
        "taplo",
        "terraform-ls",
        "tfsec",
        "tflint",
        "yaml-language-server",
        "rust-analyzer",
        "pyright"
      }
    }
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "abecodes/tabout.nvim",
    event = "BufEnter",
    config = function()
      require("tabout").setup()
    end,
  },
  {
    'edluffy/hologram.nvim',
    config = function ()
      require("hologram").setup({
        auto_display = true
      })
    end
  },
    {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function (_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function ()
       vim.cmd [[silent! GoInstallDeps]]
    end
  },
  {
    "pearofducks/ansible-vim",
    ft = { 'ansible', 'ansible_hosts', 'jinja2', 'yaml.ansible' },
  },
	{

		"kdheepak/lazygit.nvim",
		dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
    cmd = {
			"LazyGit",
			"LazyGitCurrentFile",
			"LazyGitFilterCurrentFile",
			"LazyGitFilter",
		},
		config = function()
      require("telescope").load_extension("lazygit")
			require("core.utils").load_mappings("lazygit")
      vim.g.lazygit_floating_window_scaling_factor = 1
		end,
	},
  {
    "andweeb/presence.nvim",
    event = "VeryLazy"
  },
  {
    "zbirenbaum/copilot.lua",
    event = {
      "InsertEnter"
    },
    opts = overrides.copilot
  },
  {
    "folke/todo-comments.nvim",
    cmd = {
      "TodoTrouble",
      "TodoTelescope"
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "folke/trouble.nvim",
    cmd = {
      "Trouble",
      "TroubleToggle"
    },
    opts = {
      -- use_diagnostic_signs = true
    },
    event = "VeryLazy"
  },
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionsMenu",
    config = function ()
      require("core.utils").load_mappings("code_actions_menu")
    end,
    lazy=false,
    event = "BufEnter"
  },
  {
    "saecki/crates.nvim",
    ft = {
      "rust",
      "toml"
    },
    config = function (_, opts)
      local crates = require("crates")
      crates.setup(opts)
      crates.show()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function ()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, {name = "crates"})
      return  M
    end
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function ()
      require("symbols-outline").setup()
    end,
    cmd = {"SymbolsOutline"}
  },
  {
    "Bekaboo/deadcolumn.nvim",
		event = 'BufReadPost',
		opts = {
			scope = 'visible',
		},
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
	  "theRealCarneiro/hyprland-vim-syntax",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = "hypr",
	},
  {
    "filNaj/tree-setter"
  }
}

return plugins
