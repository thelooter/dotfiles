local M = {}

local util = require("lspconfig.util")

local servers = {
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
      },
    },
  },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  pyright = {},
  rust_analyzer = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {
            "vim",
            "awesome",
            "screen",
            "client",
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
        hint = {
          enable = true,
        },
      },
    },
  },
  ts_ls = {
    disable_formatting = true,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
  vimls = {},
  kotlin_language_server = {},
  dockerls = {},
  yamlls = {},
  bashls = {},
  gradle_ls = {
    cmd = {
      vim.env.HOME
      ..
      "/.local/share/nvim/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server",
    },
    root_dir = function(fname)
      return util.root_pattern(unpack({ "settings.gradle", "settings.gradle.kts" }))(fname)
          or util.root_pattern(unpack({ "build.gradle" }))(fname)
    end,
    filetypes = { "groovy", "kotlin" },
  },
  cssls = {},
  emmet_ls = {},
  volar = {},
  clangd = {
    cmd = {
      "clangd",
      "--offset-encoding=UTF-16",
    },
  },
}

-- local lsp_signature = require "lsp_signature"
-- lsp_signature.setup {
--   bind = true,
--   handler_opts = {
--     border = "rounded",
--   },
-- }

local function on_attach(client, bufnr)
  -- Prevent duplicate LSP clients (by name) from attaching to the same buffer
  for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.id ~= client.id and c.name == client.name then
      vim.lsp.buf_detach_client(bufnr, client.id)
      vim.notify("Prevented duplicate LSP client attachment: " .. client.name, vim.log.levels.WARN)
      return
    end
  end

  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {
    buf = bufnr,
  })

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", {
    buf = 0,
  })

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  require("config.lsp.highlighting").setup(client)

  require("config.lsp.null-ls.formatters").setup(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    local navic = require("nvim-navic")
    navic.attach(client, bufnr)
  end

  if client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end

  local ih = require("inlay-hints")
  ih.on_attach(client, bufnr)

  -- Configure for jdtls
  if client.name == "jdtls" then
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()
  end
end

local capabilities

capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities) -- for nvim-cmp

local opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

require("config.lsp.handlers").setup()

function M.setup()
  -- null-ls
  require("config.lsp.null-ls").setup(opts)

  require("config.lsp.installer").setup(servers, opts)
end

return M
