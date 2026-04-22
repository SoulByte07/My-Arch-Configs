-- File: ~/.config/nvim/lua/plugins/bigfile.lua
return {
  "LunarVim/bigfile.nvim",
  lazy = true,
  event = "BufReadPre", 
  opts = {
    filesize = 2,      
    pattern = { "*" }, 
    features = {
      "indent_blankline",
      "lsp",
      "treesitter",    
      "syntax",       
      "matchparen",  
      "vimopts",    
    },
  },
  config = function(_, opts)
    require("bigfile").setup(opts)
  end,
}
