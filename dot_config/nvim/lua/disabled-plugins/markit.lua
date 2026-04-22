-- file: lua/plugins/markit.lua
return {
  "2kabhishek/markit.nvim",
  -- Efficiency: Only load when you actually open a real file
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "2kabhishek/pickme.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("markit").setup({
      -- Efficiency: Disabling mappings you don't use saves memory
      add_default_keybindings = true,
      
      -- Refresh frequency: Increased to 250ms to reduce CPU cycles
      refresh_interval = 250,
      
      -- Sign Priority: Keep it lower than GitSigns to avoid 'gutter flickering'
      sign_priority = { lower = 6, upper = 10, builtin = 4, bookmark = 15 },
      
      -- Strict Exclusions: Prevent the plugin from running on temp/heavy buffers
      excluded_filetypes = {
        "qf", "NvimTree", "toggleterm", "TelescopePrompt", 
        "alpha", "netrw", "help", "man", "terminal"
      },
      
      -- Performance: Only track the most essential builtin marks
      builtin_marks = { ".", "^" }, 
      
      -- Bookmark Groups: Reduced to one group for a smaller memory footprint
      enable_bookmarks = true,
      bookmarks = {
        { sign = "⦿", virt_text = "Task", annotate = false },
      },
    })
  end,
}

