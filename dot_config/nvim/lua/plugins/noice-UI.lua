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
        opts = { position = { row = "10%", col = "50%" } },
      },
      messages = {
        enabled = true,
        view = "popup", -- Use popup for permanence
      },
      notify = {
        enabled = true,
        view = "popup", -- Use popup for permanence
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        message = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      views = {
        popup = {
          enter = false, -- Auto-focus on notifications
          border = {
            style = "rounded",
          },
          position = { row = "10%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
      },
      routes = {
        {
          filter = { event = "notify" },
          view = "popup",
        },
        {
          filter = { event = "msg_show" },
          view = "popup",
        },
      },
    })

    -- Dismiss all notifications with ESC
    vim.keymap.set("n", "<esc>", function()
      require("noice").cmd("dismiss")
      -- Also perform standard ESC behavior if needed (optional)
      return "<esc>"
    end, { expr = true, desc = "Dismiss Noice and ESC" })
  end
}
