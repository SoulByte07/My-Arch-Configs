return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    -- Define dependencies
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      -- 1. Setup mason
      require("mason").setup()

      -- 2. Get capabilities for autocompletion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 3. Define the list of servers to install
      local lsp_servers = { "ts_ls", "html", "lua_ls",
        -- Add for Cloud/DevOps
        "pyright",  -- Python (DevOps scripts, AWS/GCP SDKs)
        "yamlls",   -- YAML (Kubernetes, CloudFormation, Ansible)
        "jsonls",   -- JSON (Terraform, CloudFormation, API responses)
        "bashls",   -- Bash scripts (most DevOps work!)
        "dockerls", -- Dockerfile
        "stylelint_lsp",
      }

      -- 4. Setup mason-lspconfig
      -- This single setup call configures everything
      require("mason-lspconfig").setup({
        -- Ensure the servers from the list above are installed
        ensure_installed = lsp_servers,

        -- Automatically install new servers
        automatic_installation = true,

        handlers = {

          -- This is the default handler for all servers
          function(server_name)
            vim.lsp.config[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["stylelint_lsp"] = function()
            require("lspconfig").stylelint_lsp.setup({
              capabilities = capabilities,
              -- You can add specific CSS settings here if needed
            })
          end,

          -- Special setup for lua_ls to make it aware of 'vim' global
          ["lua_ls"] = function()
            vim.lsp.config.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        }
      })

      -- 5. Add your keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
