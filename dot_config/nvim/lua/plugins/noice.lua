-- File: lua/plugins/noice.lua
-- Input: Typing ':' or '/'
-- Expected Output: Clean top-center UI with minimal memory footprint

return {
  "folke/noice.nvim",
  --  enabled = false,
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline_popup",
        opts = { position = { row = "10%", col = "50%" } },
      },
      -- 'routes' removed! Lualine + Neovim Core handles this now.
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
    })
  end
}
