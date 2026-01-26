return {
  'mbbill/undotree',
  config = function()
    -- Add keymap to toggle the undo tree
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndo Tree Toggle' })
  end,
}
