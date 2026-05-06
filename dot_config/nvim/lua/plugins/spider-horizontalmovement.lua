-- File: ~/.config/nvim/lua/plugins/spider.lua
return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "<leader>w",
      "<cmd>lua require('spider').motion('w')<cr>",
      mode = { "n", "o", "x" },
      desc = "Spider-w",
    },
    {
      "<leader>e",
      "<cmd>lua require('spider').motion('e')<cr>",
      mode = { "n", "o", "x" },
      desc = "Spider-e",
    },
    {
      "<leader>b",
      "<cmd>lua require('spider').motion('b')<cr>",
      mode = { "n", "o", "x" },
      desc = "Spider-b",
    },
  },
  opts = {
    skipInsignificantPunctuation = true,
    consistentOperatorPending = true,
  },
}
