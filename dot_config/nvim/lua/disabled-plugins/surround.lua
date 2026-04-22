-- File: lua/plugins/surround.lua
-- Sample Input: Cursor on the word "test", press `ysiw"` (you surround inner word with ").
-- Expected Output: The word transforms to "test" instantly.

return {
  "echasnovski/mini.surround",
  event = "BufReadPost",
  version = false,
  config = function()
    require("mini.surround").setup()
  end,
}
