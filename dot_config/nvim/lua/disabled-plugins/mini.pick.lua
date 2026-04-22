return {
  "nvim-mini/mini.pick",
  version = false,
  keys = {
    {
      "<leader>ff",
      function()
        require("mini.pick").builtin.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("mini.pick").builtin.grep_live()
      end,
      desc = "Live Grep",
    },
    {
      "<leader><leader>",
      function()
        local pick = require("mini.pick")
        local items = {}
        for _, path in ipairs(vim.v.oldfiles) do
          if vim.fn.filereadable(path) == 1 then
            items[#items + 1] = path
          end
        end
        pick.start({ source = { name = "Recent Files", items = items } })
      end,
      desc = "Recent Files",
    },
    {
      "<C-p>",
      function()
        require("mini.pick").builtin.files()
      end,
      desc = "Find Files (Ctrl+P)",
    },
  },
  opts = {
    source = {
      cwd = nil,
    },
  },
}
