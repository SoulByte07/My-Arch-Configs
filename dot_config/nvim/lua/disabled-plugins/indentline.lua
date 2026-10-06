-- file: nvim/lua/plugins/indentline.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true, -- This tracks where your cursor is
        show_start = true,
        show_end = true,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      
      local set_ibl_highlights = function()
        -- INACTIVE LINES: Dim grey (Catppuccin Surface2)
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#585b70" }) 
        
        -- ACTIVE LINE: Bright white (Catppuccin Text)
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#cdd6f4" }) 
      end

      set_ibl_highlights()

      -- Ensure Catppuccin doesn't overwrite our custom brightness logic
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_ibl_highlights,
      })
    end,
  },
}
