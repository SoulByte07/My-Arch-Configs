-- File: ~/.config/nvim/lua/plugins/obsidian.lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  
  -- This part is perfect—it keeps your Neovim fast by only loading for your vault
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/4_Backups/0_Sync/Obsidian/Obsidian-Vault/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/4_Backups/0_Sync/Obsidian/Obsidian-Vault/**.md",
  },
  
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  
  keys = {
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Today's Note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Search Vault" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: Open in App" },
  },
  
  opts = {
    workspaces = {
      {
        name = "main",
        path = vim.fn.expand("~/4_Backups/0_Sync/Obsidian/Obsidian-Vault"),
      },
    },
    
    daily_notes = {
      folder = "Journals/Daily",
      date_format = "%Y-%m-%d",
    },
    
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    
    ui = {
      enable = false, 
    },
  },
}

