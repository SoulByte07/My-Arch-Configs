-- File: lua/plugins/comment.lua
-- Sample Input: Highlight text in visual mode.
-- Expected Output: Plugin remains unloaded until you press `gc` or `gb`.

return {
  'numToStr/Comment.nvim',
  keys = {
    { "cc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
    { "cb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
  },
  opts = {
    toggler = { line = 'cc', block = 'cb' },
    opleader = { line = 'c', block = 'b' },
  },
}
