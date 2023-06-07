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
        "yaml-language-server"
      }
    }
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
  }
}

return plugins
