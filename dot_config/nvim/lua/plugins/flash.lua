-- File: lua/plugins/flash.lua
-- Sample Input: Pressing `<leader>s` (Space then 's').
-- Expected Output: Flash highlights jump targets on your screen without clashing with your surround plugin.

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    -- Changed the key from "s" to "<leader>s"
    { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
  },
}
