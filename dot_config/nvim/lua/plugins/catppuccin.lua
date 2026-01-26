return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        highlight_overrides = {
          mocha = function(cp)
            return {
              LineNr = { fg = cp.text, bg = cp.base },
              CursorLineNr = { fg = cp.lavender, style = { "bold" } },
            }
          end,
        },
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
