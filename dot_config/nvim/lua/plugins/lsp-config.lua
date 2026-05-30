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
		init = function()
			-- ==========================================
			-- Diagnostic UI Configuration (Startup)
			-- ==========================================
			local diagnostic_icons = {
				[vim.diagnostic.severity.ERROR] = "✖",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "ⓘ",
			}

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "",
					format = function(diagnostic)
						local icon = diagnostic_icons[diagnostic.severity]
						return string.format("%s %s", icon, diagnostic.message)
					end,
				},
				signs = { text = diagnostic_icons }, -- Show symbols on startup
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = " ",
				},
			})

			local opts = { noremap = true, silent = true }
			local signs_enabled = true

			-- Toggle diagnostic symbols (signs)
			vim.keymap.set("n", "<leader>ds", function()
				signs_enabled = not signs_enabled
				vim.diagnostic.config({
					signs = signs_enabled and { text = diagnostic_icons } or false,
				})
				-- Force refresh the current buffer
				vim.diagnostic.show(nil, 0)
			end, opts)

			-- Show the diagnosis message in a float
			vim.keymap.set("n", "<leader>gl", function()
				vim.diagnostic.open_float({
					border = "rounded",
					source = "always",
					scope = "line",
				})
			end, opts)
		end,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Initialize Mason-LSPConfig
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "html", "lua_ls", "pyright", "gopls" },
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

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end,
	},
}
