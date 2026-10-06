-- File: lua/plugins/completions.lua

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = { enabled = false },
          menu = { auto_show = false },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
        keymap = {
          preset = "none",
          ["<Tab>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({
                  callback = function()
                    vim.api.nvim_feedkeys(" ", "n", false)
                  end,
                })
              end
              return cmp.show()
            end,
            "fallback",
          },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<CR>"] = { "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<Esc>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.cancel()
                return true
              end
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-c>", true, false, true),
                "n",
                false
              )
              return true
            end,
          },
        },
      },
      keymap = {
        preset = "none",
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Esc>"] = { "cancel", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-d>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = {
            border = "rounded",
          },
        },
        menu = {
          border = "rounded",
          max_height = 12,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      snippets = {
        preset = "default",
      },
    },
  },
}
