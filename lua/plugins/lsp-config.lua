return {
	----------------------------------------------------------------------
	-- Mason: installs external tools
	----------------------------------------------------------------------
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	----------------------------------------------------------------------
	-- Mason ↔ LSP bridge (installation only)
	----------------------------------------------------------------------
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls" },
			})
		end,
	},

	----------------------------------------------------------------------
	-- LSP configuration (Neovim 0.11+ native API)
	----------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			------------------------------------------------------------------
			-- on_attach: buffer-local LSP keymaps
			------------------------------------------------------------------
			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = bufnr,
						silent = true,
						desc = desc,
					})
				end

				-- Navigation
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "gr", vim.lsp.buf.references, "Go to references")
				map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

				-- Hover & signature help
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

				-- Refactor
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

				-- Diagnostics
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
				map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
				map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic list")

				-- Formatting
				map("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, "Format buffer")
			end

			------------------------------------------------------------------
			-- Configure LSP servers
			------------------------------------------------------------------
			vim.lsp.config("lua_ls", {
                capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})
			vim.lsp.config("gopls", {
                capabilities = capabilities,
				on_attach = on_attach,
			})

			------------------------------------------------------------------
			-- Enable servers
			------------------------------------------------------------------
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
		end,
	},
}
