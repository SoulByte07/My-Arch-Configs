-- File: lua/plugins/completions.lua

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      
      -- Custom highlights for Catppuccin Mocha
      local colors = {
        bg = "#1e1e2e",
        surface0 = "#313244",
        overlay0 = "#6c7086",
        blue = "#89b4fa",
        mauve = "#cba6f7",
        green = "#a6e3a1",
        red = "#f38ba8",
      }

      vim.api.nvim_set_hl(0, "CmpNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "CmpBorder", { fg = colors.surface0, bg = colors.bg })
      vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = colors.surface0, bg = colors.bg })
      vim.api.nvim_set_hl(0, "CmpSel", { bg = colors.surface0, fg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = colors.overlay0, bg = "NONE", strikethrough = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = colors.blue, bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = colors.blue, bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = colors.mauve, bg = "NONE", italic = true })
      
      vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = colors.red, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = colors.red, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = colors.red, bg = "NONE" })
      
      vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = colors.green, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = colors.green, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = colors.green, bg = "NONE" })
      
      vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = colors.blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = colors.blue, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = colors.blue, bg = "NONE" })
      
      vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = colors.mauve, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = colors.mauve, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = colors.mauve, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = colors.mauve, bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = colors.mauve, bg = "NONE" })

      -- Set completeopt for better completion experience
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
            side_padding = 0,
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder,CursorLine:CmpSel,Search:None",
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
