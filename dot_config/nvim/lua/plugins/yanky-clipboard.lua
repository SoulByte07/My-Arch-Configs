-- File: ~/.config/nvim/lua/plugins/yanky.lua

return {
  "gbprod/yanky.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  -- The plugin will ONLY load when one of these keys is pressed
  keys = {
    { "y", '"+y', mode = { "n", "x" }, desc = "Yank to system clipboard" },
    { "p", '"+p', mode = { "n", "x" }, desc = "Paste from system clipboard" },
    { "Y", '"+Y', mode = { "n" }, desc = "Yank line to system clipboard" },
    { "P", '"+P', mode = { "n", "x" }, desc = "Paste before from system clipboard" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Cycle history back" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Cycle history forward" },
    { "<leader>y", ":Telescope yanky<CR>", desc = "Open Yank History" },
  },
  config = function()
    require("yanky").setup({
      ring = { storage = "sqlite" },
      system_clipboard = {
        sync_with_ring = false, -- Keeps 'd' out of system clipboard
      },
    })
    
    -- Ensure Neovim doesn't sync clipboard globally
    vim.opt.clipboard = ""
  end,
}
