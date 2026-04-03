-- File: lua/plugins/lualine.lua
-- Input: Normal Neovim startup -> Pressing 'q' to record
-- Expected Output: Lualine loads instantly. Bubble appears only when recording.

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = '',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '', right = '' } } },
        lualine_b = { { 'filename', separator = { left = '', right = '' } } },
        lualine_c = {
          -- 1. Optimized Noice Macro Recording
          {
            function() return require("noice").api.statusline.mode.get() end,
            -- cond ensures Noice isn't forcefully loaded at startup
            cond = function()
              return package.loaded["noice"] and require("noice").api.statusline.mode.has()
            end,
            color = { fg = "#ff9e64", gui = "bold" },
          },
          -- 2. Native Pending Keys
          {
            "%S",
            color = { fg = "#cba6f7", gui = "bold" },
          },
        },
        lualine_x = {},
        lualine_y = { { 'progress', separator = { left = '', right = '' } } },
        lualine_z = { { 'location', separator = { left = '', right = '' } } },
      },
    })
  end,
}
