-- File: lua/plugins/which-key.lua
-- Sample Input: Pressing <leader> (Space)
-- Expected Output: The floating menu appears at the top center of the screen

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    preset = "modern",
    win = {
      -- row = 0 puts the window at the very top of the editor
      row = 0,
      -- col = 0.5 centers the window horizontally
      col = 0.5,
      border = "none",
      padding = { 1, 2 },
      -- This ensures the window is placed relative to the editor grid
      anchor = "NW",
    },
    layout = {
      spacing = 6,
      align = "center",
    },
    spec = {
      { "<leader>f", group = "file" }, -- This labels the 'f' group as 'file'
      { "<leader>g", group = "git" },  -- This labels the 'g' group as 'git'
    },
  },
}
