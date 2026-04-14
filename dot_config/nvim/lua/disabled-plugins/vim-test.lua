return {
  "vim-test/vim-test",
  keys = {
    { "<leader>t",  "<cmd>TestNearest<cr>", desc = "Test Nearest" },
    { "<leader>T",  "<cmd>TestFile<cr>",    desc = "Test File" },
    { "<leader>ts", "<cmd>TestSuite<cr>",   desc = "Test Suite" },
    { "<leader>l",  "<cmd>TestLast<cr>",    desc = "Test Last" },
    { "<leader>tv", "<cmd>TestVisit<cr>",   desc = "Test Visit" },
  },
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'")
  end,
}
