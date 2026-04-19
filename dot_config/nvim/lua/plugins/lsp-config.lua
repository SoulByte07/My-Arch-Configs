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
      -- 1. Foundation: Enable standard, lightweight Vim syntax
      vim.cmd("syntax enable")

      require("mason").setup()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

          -- Specific Stylelint setup
          ["stylelint_lsp"] = function()
            require("lspconfig").stylelint_lsp.setup({
              capabilities = capabilities,
              settings = {
                autoFixOnSave = false, 
              },
            })
          end,
        }
      })

      -- 2. The Bridge: Link LSP semantic tokens to standard Vim highlight groups
      vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "Identifier", default = true })
      vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "Function", default = true })
      vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "Identifier", default = true })
      vim.api.nvim_set_hl(0, "@lsp.type.keyword", { link = "Keyword", default = true })
      vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "Type", default = true })

      -- 3. Keybindings 
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
  }
}
