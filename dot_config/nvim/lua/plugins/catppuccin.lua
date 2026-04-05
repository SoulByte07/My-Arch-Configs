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
        transparent_background = true, -- Matches your requested solid UI
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        compile_check = true,
        integrations = {
          bufferline = true, -- Still keep this for general compatibility
          harpoon = true,
        },
        custom_highlights = function(colors)
          return {
            LineNr = { fg = colors.yellow, style = { "bold" } },
            CursorLineNr = { fg = "#ff8c00", style = { "bold" } }, -- Safety Orange
          }
        end,
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
}
