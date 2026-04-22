return {
  'mbbill/undotree',
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
  },
  config = function()
    -- 1. Focus the undotree window when it opens
    vim.g.undotree_SetFocusWhenToggle = 1
    -- 2. Hide the 'diff' window by default to keep the UI clean
    vim.g.undotree_DiffAutoOpen = 1
    -- 3. Use a cleaner layout (Tree on left, no redundant panels)
    vim.g.undotree_WindowLayout = 1
  end,
}
