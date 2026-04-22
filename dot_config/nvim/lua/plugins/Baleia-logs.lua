-- file: lua/plugins/baleia-logs.lua

return {
  "m00qek/baleia.nvim",
  ft = { "log" },
  cmd = { "BaleiaColorize" },
  config = function()
    local baleia = require("baleia").setup({
      async = true,          -- Run in background
      chunk_size = 1000,     -- Process 1000 lines at a time for speed
      strip_ansi_codes = true, -- Remove raw codes to clean the view
    })

    -- Manual command: :BaleiaColorize
    vim.api.nvim_create_user_command("BaleiaColorize", function()
      baleia.once(vim.api.nvim_get_current_buf())
    end, { desc = "Colorize ANSI codes in current buffer" })

    -- Automatic trigger for specific filetypes
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
      pattern = "*.log",
      callback = function()
        baleia.automatically(vim.api.nvim_get_current_buf())
      end,
    })
  end,
}
