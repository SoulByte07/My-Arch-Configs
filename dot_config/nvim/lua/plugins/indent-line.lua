-- File: lua/plugins/indent-line.lua

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  opts = {},
}
