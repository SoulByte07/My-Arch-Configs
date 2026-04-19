--  File: ~/.config/nvim/lua/plugins/tabout.lua
return {
  "abecodes/tabout.nvim",
  event = "InsertEnter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Already in your list, used for smart context
    "hrsh7th/nvim-cmp",                -- Links to your completions.lua
  },
  opts = {
    tabkey = "<Tab>",               -- Standard jump
    backspacespace_key = "<S-Tab>", -- Reverse jump
    completion = true,              -- Important: Yields to your completion menu
    ignore_beginning = false,       -- Don't "tab out" if you're just trying to indent
    act_as_tab = true,              -- Behave like a normal tab when not in brackets
    enable_backwards = true,        -- Allow Shift-Tab to go back
  },
}
