-- File: lua/plugins/vim-markdown.lua

return {
  "plasticboy/vim-markdown",
  event = "BufReadPre",
  ft = "markdown",
  dependencies = { "godlygeek/tabular" }, -- Required for alignment
  config = function()
    -- Disable the default header folding if you find it annoying
    vim.g.vim_markdown_folding_disabled = 1
    -- Enable concealing (hiding the markdown syntax)
    vim.opt.conceallevel = 2
  end,
}
