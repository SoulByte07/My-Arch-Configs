-- File: lua/plugins/todo-comments.lua
-- Sample Input: Typing `# TODO: refactor this loop` in a Python script.
-- Expected Output: The word `TODO` is highlighted with a bright yellow background and a checkmark icon.

return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- Default settings automatically highlight TODO, FIXME, WARNING, etc.
  }
}
