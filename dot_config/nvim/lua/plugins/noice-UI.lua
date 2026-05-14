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
        timeout = 3000,
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
        view = "mini",
      },
      notify = {
        enabled = true,
        view = "notify",
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
          enter = false,
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
            winblend = 5,
          },
          position = { row = "10%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
        cmdline_popup = {
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          filter_options = { reverse = true },
          win_options = {
            winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
          },
        },
      },
      routes = {
        {
          filter = { event = "notify" },
          view = "notify",
        },
        {
          filter = { event = "msg_show" },
          view = "mini",
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
