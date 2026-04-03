return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    cmd = "Telescope",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<C-p>",            "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>ff",       "<cmd>Telescope find_files<cr>", desc = "Find Files (Leader)" },
    { "<leader>fg",       "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
    { "<leader><leader>", "<cmd>Telescope oldfiles<cr>",   desc = "Recent Files" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    require("telescope").load_extension("ui-select")
  end,
}
