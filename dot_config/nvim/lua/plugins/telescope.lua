return {
  "nvim-telescope/telescope.nvim",
  -- branch = "0.1.x",
  -- 1. This tells Lazy.nvim: "Don't load this until these keys are pressed"
  keys = {
    { "<leader>ff",       "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg",       "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
    { "<leader><leader>", "<cmd>Telescope oldfiles<cr>",   desc = "Recent Files" },
    { "<C-p>",            "<cmd>Telescope find_files<cr>", desc = "Find Files (Ctrl+P)" },
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
        -- Keep your RAM-saving limits!
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        preview = {
          filesize_limit = 0.1, -- 100KB limit
          timeout = 200,
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

-- Sample Input: Open Neovim and run `:Lazy`.
-- Expected Output: Telescope will be in the "Not Loaded" list until you press `<leader>ff`.
