-- File: lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true, -- Matches your requested solid UI
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        compile_check = true,
        integrations = {
          bufferline = false,
          harpoon = false,
          cmp = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          treesitter = true,
          notify = true,
          mini = true,
        },
        custom_highlights = function(colors)
          return {
            LineNr = { fg = "#cba6f7",  },
            CursorLineNr = { fg = "#babbf1", style = { "bold" } }, -- Safety Orange
            DiagnosticWarn = { fg = "#cba6f7" },
            DiagnosticSignWarn = { fg = "#cba6f7" },
            DiagnosticHint = { fg = "#cba6f7" },
            DiagnosticSignHint = { fg = "#cba6f7" },
          }
        end,
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
}
