-- File: lua/plugins/indent-line.lua
-- Sample Input: Opening a file with deeply nested if-statements.
-- Expected Output: Vertical lines render seamlessly to guide your eyes down the indentation levels.

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  opts = {},
}
