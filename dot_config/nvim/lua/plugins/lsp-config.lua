-- File: ~/.config/nvim/lua/plugins/lsp.lua

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      require("mason").setup()

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 1. Using "stylelint_lsp" to satisfy mason-lspconfig
      local lsp_servers = {
        "ts_ls", "html", "lua_ls", "pyright",
        "yamlls", "jsonls", "bashls", "dockerls",
        "stylelint_lsp",
      }

      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
        automatic_installation = true,

        handlers = {
          -- Default handler
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific Lua setup
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = { diagnostics = { globals = { "vim" } } },
              },
            })
          end,

          -- 2. Specific Stylelint setup using the recognized name
          ["stylelint_lsp"] = function()
            require("lspconfig").stylelint_lsp.setup({
              capabilities = capabilities,
              settings = {
                autoFixOnSave = false, -- Your "Manual only" preference
              },
            })
          end,
        }
      })

      -- 3. Keybindings
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      -- Manual Format Trigger
      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
        print("Code Format: Style applied! ✨")
      end, { desc = "Manual LSP Format" })
    end,
  },
}
