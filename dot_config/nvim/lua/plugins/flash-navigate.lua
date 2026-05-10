-- File: lua/plugins/flash.lua

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
  },
  config = function(_, opts)
    require("flash").setup(opts)
    -- Explicitly remap f to flash.jump if lazy-loading fails to take over
    vim.keymap.set({ "n", "x", "o" }, "f", function()
      require("flash").jump()
    end, { desc = "Flash Jump" })
  end,
}
