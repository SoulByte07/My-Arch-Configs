-- File: lua/plugins/render-markdown.lua
-- Sample Input: Opening a README.md file containing `# Title` and `**bold text**`.
-- Expected Output: Displays a large, clean "Title" with a styled icon. Moving your cursor to that line makes the `#` reappear so you can edit the raw text.

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
