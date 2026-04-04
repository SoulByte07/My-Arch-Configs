-- File: lua/plugins/lualine.lua
-- Input: Open Neovim without opening any specific files
-- Expected Output: Lualine's native buffer UI instantly displays all previously saved Harpoon files with their correct indices (1:, 2:, etc.)

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'ThePrimeagen/harpoon'
  },
  config = function()
    -- NEW: Pre-load Harpoon files into Neovim's temporary buffer list on startup
    local function preload_harpoon_buffers()
      local ok, mark = pcall(require, "harpoon.mark")
      if not ok then return end

      -- Loop through Harpoon's saved list and register them in the background
      for i = 1, mark.get_length() do
        local file_path = mark.get_marked_file_name(i)
        if file_path and file_path ~= "" then
          local bufnr = vim.fn.bufadd(file_path)
          vim.fn.setbufvar(bufnr, "&buflisted", 1) -- Tells Neovim to show it in the buffer list
        end
      end
    end

    -- Run the pre-loader before setting up Lualine
    preload_harpoon_buffers()

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
          {
            'buffers',
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 0,
            max_length = vim.o.columns * 2 / 3,
            symbols = {
              modified = ' ●',
              alternate_file = '#',
              directory = '',
            },
            -- Injects Harpoon numbers into the native UI
            fmt = function(name)
              local ok, mark = pcall(require, "harpoon.mark")
              if not ok then return name end

              for i = 1, mark.get_length() do
                local harpoon_filename = vim.fn.fnamemodify(mark.get_marked_file_name(i), ":t")
                if name == harpoon_filename then
                  return i .. ": " .. name
                end
              end
              return name
            end,
          },
          -- Optimized Noice Macro Recording
          {
            function() return require("noice").api.statusline.mode.get() end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.statusline.mode.has()
            end,
            color = { fg = "#ff9e64", gui = "bold" },
          },
        },
        lualine_x = { "%S" },
        lualine_y = { { 'progress', separator = { left = '', right = '' } } },
        lualine_z = { { 'location', separator = { left = '', right = '' } } },
      },
    })
  end,
}
