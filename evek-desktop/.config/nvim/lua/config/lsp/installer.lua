local M = {}

function M.setup(servers, options)
  local lspconfig = require "lspconfig"
  local icons = require "config.icons"

  require("mason").setup {
    ui = {
      icons = {
        package_installed = icons.server_installed,
        package_pending = icons.server_pending,
        package_uninstalled = icons.server_uninstalled,
      },
    },
  }

  require("mason-tool-installer").setup {
    ensure_installed = {
      "codelldb",
      "stylua",
      "shfmt",
      "shellcheck",
      "black",
      "isort",
      "prettierd"
    },
    auto_update = false,
    run_on_start = true,
  }

  require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
  }

  -- Package installation folder
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local opts = vim.tbl_deep_extend("force", options, servers[server_name] or {})
      lspconfig[server_name].setup { opts }
    end,
    ["lua_ls"] = function()
      local opts = vim.tbl_deep_extend("force", options, servers["lua_ls"] or {})
      require("neodev").setup {}
      lspconfig.lua_ls.setup(opts)
    end,
    ["rust_analyzer"] = function()
      local opts = vim.tbl_deep_extend("force", options, servers["rust_analyzer"] or {})
      local ih = require "inlay-hints"
      require("rust-tools").setup {
        tools = {
          -- executor = require("rust-tools/executors").toggleterm,
          hover_actions = { border = "solid" },
          on_initialized = function()
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
              pattern = { "*.rs" },
              callback = function()
                vim.lsp.codelens.refresh()
              end,
            })
            ih.set_all()
          end,
          inlay_hints = {
            auto = false,
          },
        },
      }
      lspconfig.rust_analyzer.setup(opts)
    end
  }
end

return M
