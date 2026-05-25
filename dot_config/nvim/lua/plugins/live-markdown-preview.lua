-- file: /lua/plugins/live-markdown-preview.lua

return {
  "brianhuster/live-preview.nvim",
  dependencies = { "echasnovski/mini.icons" }, 
  ft = { "markdown" }, 
  cmd = { "LivePreview" }, 
  
  keys = {
    { "<leader>mp", "<cmd>LivePreview start<cr>", desc = "Start Browser Preview" },
    { "<leader>mc", "<cmd>LivePreview close<cr>", desc = "Close Browser Preview" },
  },
  
  opts = {
    port = 5555, 
    browser = "brave-origin-beta", 
    sync_scroll = true, 
    dynamic_root = true, 
  },
}
