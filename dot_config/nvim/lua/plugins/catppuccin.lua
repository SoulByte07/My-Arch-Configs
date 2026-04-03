-- File: lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin", -- Faster loading
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
