-- File: ~/.config/nvim/lua/plugins/mini-animate.lua

return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  -- Don't load if the file is too large (e.g., > 100KB)
  cond = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    return not (stats and stats.size > 100000)
  end,
  config = function()
    local animate = require("mini.animate")
    
    animate.setup({
      -- Cursor: The most important for tracking your position
      cursor = {
        timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
      },

      -- Scroll: Keep it fast so it doesn't "rubber band"
      scroll = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
      },

      -- Resize: Disable to save resources during layout changes
      resize = {
        enable = false,
      },

      -- Window: Disable to keep window jumps instant
      window = {
        enable = false,
      },
    })
  end,
}
