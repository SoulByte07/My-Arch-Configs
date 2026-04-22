-- File: lua/plugins/bufferline.lua



return {

  {

    "akinsho/bufferline.nvim",

    event = "VeryLazy",

    dependencies = { "catppuccin", "ThePrimeagen/harpoon" },

    opts = function(_, opts)
      -- 1. LOCALIZATION (Zero global table lookups)

      local mark = require("harpoon.mark")

      local get_name = vim.api.nvim_buf_get_name



      -- EXTRA SQUEEZE: Localize specific functions used inside high-frequency loops

      local get_mark = mark.get_marked_file_name

      local fnamemodify = vim.fn.fnamemodify



      -- 2. SILENT THEME INTEGRATION

      local status, catppuccin_hl = pcall(require, "catppuccin.groups.integrations.bufferline")

      if status then opts.highlights = catppuccin_hl.get() end



      opts.options = opts.options or {}

      opts.options.always_show_bufferline = true

      opts.options.separator_style = "thin"

      opts.options.show_buffer_close_icons = false

      opts.options.show_close_icon = false



      -- 3. OPTIMIZED FILTER

      opts.options.custom_filter = function(buf_id)
        local b_path = fnamemodify(get_name(buf_id), ":.")

        for i = 1, 5 do
          if get_mark(i) == b_path then return true end
        end

        return false
      end



      -- 4. OPTIMIZED FORMATTER

      opts.options.name_formatter = function(buf)
        local b_path = fnamemodify(buf.path, ":.")

        for i = 1, 5 do
          if get_mark(i) == b_path then
            return i .. ": " .. buf.name
          end
        end

        return buf.name
      end
    end,



    config = function(_, opts)
      require("bufferline").setup(opts)



      -- 5. LOW-OVERHEAD STARTUP INJECTION

      local mark = require("harpoon.mark")

      local get_mark = mark.get_marked_file_name

      local bufadd = vim.fn.bufadd



      for i = 1, 5 do
        local file = get_mark(i)

        if file and file ~= "" then
          local buf = bufadd(file)

          if not vim.bo[buf].buflisted then
            vim.bo[buf].buflisted = true
          end
        end
      end
    end,

  },

}
