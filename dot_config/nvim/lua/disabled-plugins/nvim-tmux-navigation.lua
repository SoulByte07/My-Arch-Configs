-- File: lua/plugins/nvim-tmux-navigation.lua

return {
  "alexghergh/nvim-tmux-navigation",
  keys = {
    { "<C-h>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLeft() end, desc = "Tmux/Split Left" },
    { "<C-j>", function() require("nvim-tmux-navigation").NvimTmuxNavigateDown() end, desc = "Tmux/Split Down" },
    { "<C-k>", function() require("nvim-tmux-navigation").NvimTmuxNavigateUp() end, desc = "Tmux/Split Up" },
    { "<C-l>", function() require("nvim-tmux-navigation").NvimTmuxNavigateRight() end, desc = "Tmux/Split Right" },
  },
  config = function()
    local nvim_tmux_nav = require("nvim-tmux-navigation")
    nvim_tmux_nav.setup({
      disable_when_zoomed = true, -- Avoid pane switching when tmux pane is zoomed
    })
  end,
}
