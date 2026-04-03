return {
  "alexghergh/nvim-tmux-navigation",
  keys = {
    { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>",  desc = "Tmux Left" },
    { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>",  desc = "Tmux Down" },
    { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>",    desc = "Tmux Up" },
    { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", desc = "Tmux Right" },
  },
  config = function()
    require('nvim-tmux-navigation').setup({})
  end,
}
