-- File: lua/plugins/copilot.lua

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  keys = {
    { "<leader>ct", function() require("copilot.command").toggle() end, desc = "Toggle Copilot" },
  },
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 100,
        keymap = {
          accept = "<C-f>",  -- Ctrl + j (Accept/Yes)
          next = "<C-j>",    -- Ctrl + f (Next)
          prev = "<C-b>",    -- Ctrl + b (Prev)
          dismiss = "<C-g>", -- Ctrl + g (Exit/Dismiss)
        },
      },
      panel = { enabled = false },
    })
  end,
}
