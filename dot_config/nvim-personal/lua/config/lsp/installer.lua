local M = {}

function M.setup(servers, options)
	local lspconfig = require("lspconfig")
	local icons = require("config.icons")

	require("mason").setup({
		ui = {
			icons = {
				package_installed = icons.server_installed,
				package_pending = icons.server_pending,
				package_uninstalled = icons.server_uninstalled,
			},
		},
	})

	require("mason-tool-installer").setup({
		ensure_installed = {
			"codelldb",
			"stylua",
			"shfmt",
			"shellcheck",
			"black",
			"isort",
			"prettierd",
		},
		auto_update = false,
		run_on_start = true,
	})

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_installation = false,
	})

	-- Set up each LSP server
	for server_name, server_opts in pairs(servers) do
		local opts = vim.tbl_deep_extend("force", options, server_opts or {})
		if server_name == "rust_analyzer" then
		--	local ih = require("inlay-hints")
			require("rust-tools").setup({
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
		--				ih.set_all()
					end,
					inlay_hints = {
						auto = false,
					},
				},
			})
			lspconfig.rust_analyzer.setup(opts)
    elseif server_name == "gopls" then
      require('lspconfig').gopls.setup(require'go.lsp'.config())
	else
			lspconfig[server_name].setup(opts)
		end
	end
end

return M
