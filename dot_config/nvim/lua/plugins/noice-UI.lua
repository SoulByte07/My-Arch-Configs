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
        stages = "static", -- Most efficient static rendering stage
        timeout = 2500,
        max_height = 6,
        max_width = 45,
      },
    },
  },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline_popup",
        opts = { position = { row = "20%", col = "50%" } },
        format = {
          cmdline = { icon = ":" },
          search_down = { icon = " " },
          search_up = { icon = " " },
        },
      },
      messages = {
        enabled = true,
        view = "mini",
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      popupmenu = {
        enabled = true, -- Enable floating completion menu
        backend = "nui", -- High-performance NUI dropdown
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        progress = {
          enabled = false, -- Eliminates constant background compiler flashes
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
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
            winblend = 0, -- 0 compositing lag
          },
          position = { row = "20%", col = "50%" },
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
            winblend = 0,
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = "27%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
            max_height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
            winblend = 0,
          },
        },
      },
      routes = {
        -- Skip search count messages to prevent lag during rapid `n`/`N` presses
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
        -- Filter out noisy "written" messages on buffer save
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        -- Route standard notifications to notify
        {
          filter = { event = "notify" },
          view = "notify",
        },
        -- Route general messages to mini view
        {
          filter = { event = "msg_show" },
          view = "mini",
        },
      },
    })

    -- Dismiss all notifications and clear search highlights with ESC
    vim.keymap.set("n", "<esc>", function()
      vim.cmd("nohlsearch")
      pcall(function() require("noice").cmd("dismiss") end)
      return "<esc>"
    end, { expr = true, desc = "Dismiss Noice and clear search highlights" })
  end,
}
