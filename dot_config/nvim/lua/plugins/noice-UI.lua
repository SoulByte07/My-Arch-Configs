-- File: lua/plugins/noice.lua

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#1e1e2e",
        render = "compact",
        stages = "static", -- Most efficient animation stage
      },
    },
  },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline_popup",
        opts = { position = { row = "20%", col = "50%" } },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    })
  end
}
