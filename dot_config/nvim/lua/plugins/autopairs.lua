-- File: lua/plugins/autopairs.lua
-- Sample Input: Typing `{` while in insert mode.
-- Expected Output: Neovim instantly outputs `{}` and places your cursor in the middle.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})
  end,
}
