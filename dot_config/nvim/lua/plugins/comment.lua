-- File: lua/plugins/comment.lua
return {
  'numToStr/Comment.nvim',
  opts = {
    -- Mappings for 'normal' mode
    toggler = {
      line = 'cc',        -- Comments/uncomments current line
      block = 'cb',       -- Comments/uncomments using block
    },
    -- Mappings for 'operator-pending' mode (motions)
    opleader = {
      line = 'c',        -- Used for 'c9j' or 'cip' (comment in paragraph)
      block = 'b',       -- Used for 'b9j' (block comment next 9 lines)
    },
  },
}
