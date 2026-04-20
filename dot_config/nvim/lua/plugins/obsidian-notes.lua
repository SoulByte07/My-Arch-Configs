-- File: ~/.config/nvim/lua/plugins/obsidian.lua

return {
    "epwalsh/obsidian.nvim",
    version = "*",  
    lazy = true,
    
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/4_Backups/0_Sync/Obsidian/Obsidian-Vault",
        "BufNewFile " .. vim.fn.expand("~") .. "/4_Backups/0_Sync/Obsidian/Obsidian-Vault",
    },
    
    keys = {
        { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
        { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open Today's Note" },
        { "<leader>oi", "<cmd>ObsidianTemplate<cr>", desc = "Insert Obsidian Template" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian Notes" },
        { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: Visit/Follow Link" },
    },

    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/4_Backups/0_Sync/Obsidian/Obsidian-Vault", 
            },
        },
        
        ui = {
            enable = false, 
        },

        daily_notes = {
            folder = "Journals/Daily",
            date_format = "%Y-%m-%d",
        },

        wiki_link_func = function(opts)
            return require("obsidian.util").wiki_link_id_prefix(opts)
        end,
    },
}
