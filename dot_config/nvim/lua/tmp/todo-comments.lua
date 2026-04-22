-- File: lua/plugins/todo-comments.lua

return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- Default settings automatically highlight TODO, FIXME, WARNING, etc.
  }
}
