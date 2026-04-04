-- File: ~/.config/nvim/lua/plugins/lsp.lua
-- Purpose: Modular LSP configuration with manual formatting trigger

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      -- 1. Initialize Mason
      require("mason").setup()

      -- 2. Capabilities for autocompletion integration
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 3. Modern server list (Updated: stylelint)
      local lsp_servers = {
        "ts_ls", "html", "lua_ls", "pyright",
        "yamlls", "jsonls", "bashls", "dockerls",
        "stylelint",
      }

      -- 4. Mason-lspconfig bridge
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
        automatic_installation = true,

        handlers = {
          -- Default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific logic for Lua (recognizing 'vim' global)
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
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

          -- Specific logic for Stylelint (Manual mode)
          ["stylelint"] = function()
            require("lspconfig").stylelint.setup({
              capabilities = capabilities,
              settings = {
                autoFixOnSave = false, -- Keep it manual for performance
              },
            })
          end,
        }
      })

      -- 5. Keybindings (The "Consultant's Toolkit")
      local opts = { noremap = true, silent = true }

      -- Standard Navigation
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
        print("Style applied! ✨")
      end, { desc = "Manual LSP Format" })
    end,
  },
}
