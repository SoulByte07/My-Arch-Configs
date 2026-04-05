-- File: lua/plugins/render-markdown.lua

return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "BufReadPre",
  -- Links to plugins you already have installed
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  -- Only load this plugin when you open a markdown file to save memory
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      -- This setting is what creates the "Obsidian" effect
      anti_conceal = {
        enabled = true,
      },
    })

    -- This native Vim setting is required to allow plugins to hide text
    vim.opt.conceallevel = 2
  end,
}
