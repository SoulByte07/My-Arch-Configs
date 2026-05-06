-- File: ~/.config/nvim/lua/plugins/lsp-config.lua

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ensure_installed = {
						"stylua",
						"prettier",
					},
				},
				config = function(_, opts)
					require("mason").setup(opts)
				end,
			},
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Initialize Mason-LSPConfig (Mason itself is initialized in dependencies)
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "html", "lua_ls", "pyright" },
				automatic_installation = true,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" },
									},
								},
							},
						})
					end,
				},
			})

			-- ==========================================
			-- Diagnostic UI Configuration (Clean Default)
			-- ==========================================

			-- Define icons for use during toggle
			local diagnostic_icons = {
				[vim.diagnostic.severity.ERROR] = "✖",
				[vim.diagnostic.severity.WARN] = "⚠",
				[vim.diagnostic.severity.HINT] = "💡",
				[vim.diagnostic.severity.INFO] = "ⓘ",
			}

			vim.diagnostic.config({
				virtual_text = false,
				signs = false, -- Start with logos hidden for a clean screen
				underline = false, -- Start with underlines hidden
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- 3. The Keybinding
			local opts = { noremap = true, silent = true }
			local diag_enabled = false

			-- Toggle diagnostics and open float on 'gl'
			vim.keymap.set("n", "gl", function()
				diag_enabled = not diag_enabled
				vim.diagnostic.config({
					signs = diag_enabled and { text = diagnostic_icons } or false,
					underline = diag_enabled,
				})

				if diag_enabled then
					vim.diagnostic.show(nil, 0) -- Force redraw for current buffer
					vim.diagnostic.open_float({
						border = "rounded",
						source = "always",
						scope = "line",
					})
				else
					vim.diagnostic.hide(nil, 0) -- Force hide for current buffer
				end
			end, opts)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		end,
	},
}
