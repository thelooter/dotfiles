local M = {}

function M.setup(servers, options)
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

	-- Set up each LSP server using the new `vim.lsp.config` / `vim.lsp.enable` API
	for server_name, server_opts in pairs(servers) do
		local opts = vim.tbl_deep_extend("force", options, server_opts or {})
		if server_name == "gopls" then
			vim.lsp.config("gopls", require("go.lsp").config())
			vim.lsp.enable("gopls")
		else
			vim.lsp.config(server_name, opts)
			vim.lsp.enable(server_name)
		end
	end
end

return M
