return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e",  "<cmd>Neotree toggle<cr>",                 desc = "Toggle Explorer" },
    { "<C-n>",      "<cmd>Neotree filesystem reveal left<cr>", desc = "Explorer Reveal" },
    { "<leader>bf", "<cmd>Neotree buffers reveal float<cr>",   desc = "Floating Buffers" },
  },
  config = function()
  end,
}
