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
        transparent_background = true, -- Essential for Hyprland blur/transparency
        integrations = {
          bufferline = true,           -- The official handshake
          harpoon = true,
        },
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
}
