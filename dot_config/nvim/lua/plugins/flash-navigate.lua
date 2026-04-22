-- File: lua/plugins/flash.lua

return {
  "folke/flash.nvim",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
  },
}
