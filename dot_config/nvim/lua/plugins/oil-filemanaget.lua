return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", function() require("oil").toggle_float() end, desc = "Toggle Oil floating file manager" },
  },
  lazy = false,
  opts = {
    default_file_explorer = true,
  },
  config = function(_, opts)
    require("oil").setup(opts)
  end,
}
