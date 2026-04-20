-- File: lua/plugins/completions.lua
return {
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*',
    build = 'cargo build --release',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'L3MON4D3/LuaSnip', 
    },

    opts = {
      keymap = { 
        preset = 'enter',
        ['<Tab>'] = { 'fallback' },
        ['<S-Tab>'] = { 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      completion = {
        documentation = { 
          auto_show = true, 
          auto_show_delay_ms = 500 
        },
        menu = {
          border = 'rounded',
          max_height = 10, 
        },
        list = { selection = { preselect = true, auto_insert = true } },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      snippets = { preset = 'luasnip' },
    },
  },
}
