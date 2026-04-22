-- File: ~/.config/nvim/lua/plugins/conform.lua

return {
  'stevearc/conform.nvim',
  -- Loads the plugin when a file is opened
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ 
          async = true, 
          lsp_format = "fallback" 
        })
        print("Code Format: Applied! ✨")
      end,
      mode = "",
      desc = "Manual Conform Format",
    },
  },
  
  opts = {
    -- Set up your manual formatters
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
  },
}
