-- File: lua/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    -- 1. Initialize autopairs 
    require("nvim-autopairs").setup({
      check_ts = false,
    })

    -- 2. Inject the Tab-out logic
    vim.keymap.set('i', '<Tab>', function()
      local col = vim.fn.col('.') - 1
      local char_after = vim.fn.getline('.'):sub(col + 1, col + 1)
      
      -- Check if the next character is a closing pair
      if char_after:match('^[%)%}%]%”%’%"%\']') then
        return '<Right>' -- Escape the bracket
      else
        return '<Tab>'   -- Normal indent
      end
    end, { expr = true, noremap = true, silent = true, desc = "Tab out of brackets natively" })
  end,
}
