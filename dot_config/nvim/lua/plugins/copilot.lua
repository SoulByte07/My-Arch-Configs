-- File: lua/plugins/copilot.lua
-- VS Code style with Tmux-safe Ctrl keybindings

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",  -- tab (Accept/Yes)
          next = "<C-f>",    -- Ctrl + f (Next)
          prev = "<C-b>",    -- Ctrl + b (Prev)
          dismiss = "<C-g>", -- Ctrl + g (Exit/Dismiss)
        },
      },
      panel = { enabled = false },
    })
  end,
}
