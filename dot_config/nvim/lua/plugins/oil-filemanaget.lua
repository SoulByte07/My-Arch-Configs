return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = { "-" },
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", require("oil").toggle_float, {})
  end,
}
