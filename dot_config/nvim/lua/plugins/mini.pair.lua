return {
  "nvim-mini/mini.pairs",
  version = false,
  event = "InsertEnter",
  config = function()
    require("mini.pairs").setup()

    vim.keymap.set("i", "<Tab>", function()
      local col = vim.fn.col(".") - 1
      local char_after = vim.fn.getline("."):sub(col + 1, col + 1)

      if char_after:match("^[%)%}%]\"']") then
        return "<Right>"
      end

      return "<Tab>"
    end, {
      expr = true,
      noremap = true,
      silent = true,
      desc = "Tab out of pairs",
    })
  end,
}
