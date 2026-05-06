-- File: ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  -- 1. This tells Lazy.nvim: "Don't load this until these keys are pressed"
  keys = {
    { "<leader>ff",       "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg",       "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
    { "<leader>fo",       "<cmd>Telescope oldfiles<cr>",   desc = "Old Files" },
    { "<leader>fb",       "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
    { "<leader>fh",       "<cmd>Telescope help_tags<cr>",  desc = "Help Tags" },
  },
  -- 2. Also load if the user types :Telescope in the command line
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        preview = {
          filesize_limit = 0.1, -- 100KB limit
          timeout = 200,
        },
        
        -- UI Layout Configuration
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            mirror = true,              -- Puts preview at the top
            -- prompt_position = "bottom", -- Keeps input field at the bottom
            height = 0.95,               -- Total window takes up 90% of the screen
            preview_height = 0.65,      -- Preview takes up 75% of the window, shrinking the results list
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    telescope.load_extension("ui-select")
    telescope.load_extension("fzf")
  end,
}

