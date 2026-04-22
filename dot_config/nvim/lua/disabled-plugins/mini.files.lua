return {
  "nvim-mini/mini.files",
  version = false,
  keys = {
    {
      "-",
      function()
        local mini_files = require("mini.files")
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then
          path = nil
        end
        if not mini_files.close() then
          mini_files.open(path, true)
        end
      end,
      desc = "Toggle file explorer",
    },
  },
  opts = {
    windows = {
      preview = true,
      width_focus = 50,
    },
  },
}
