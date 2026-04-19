-- File: ~/.config/nvim/lua/plugins/conform.lua

return {
  'stevearc/conform.nvim',
  cmd = { "ConformInfo" },
  
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ 
          async = true, 
          lsp_format = "fallback" 
        })
        print("Code Format: Conform applied! ✨")
      end,
      mode = "",
      desc = "Manual Conform Format",
    },
  },
  
  opts = {
    -- Set up formatters
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
