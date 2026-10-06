-- File: ~/.config/nvim/lua/plugins/yanky.lua
return {
  "gbprod/yanky.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  keys = {
    -- 1. System Clipboard Interactions (External)
    { "y", '"+y', mode = { "n", "x" }, desc = "Yank to system clipboard" },
    { "p", '"+p', mode = { "n", "x" }, desc = "Paste from system clipboard" },
    { "Y", '"+Y', mode = { "n" }, desc = "Yank line to system clipboard" },
    { "P", '"+P', mode = { "n", "x" }, desc = "Paste before from system clipboard" },
    
    -- 2. Internal Vim Clipboard Interactions (The 'd' fix)
    { "<leader>p", '""p', mode = { "n", "x" }, desc = "Paste from Vim internal clipboard" },

    -- 3. Yanky History Navigation
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Cycle history back" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Cycle history forward" },
    { "<leader>y", ":Telescope yank_history<CR>", desc = "Open Yank History" },
  },
  config = function()
    -- Explicitly sever the tie between Vim's general operations and the Arch OS clipboard
    -- This ensures 'd' stays purely internal.
    vim.opt.clipboard = ""

    require("yanky").setup({
      ring = { storage = "sqlite" },
      system_clipboard = {
        sync_with_ring = false, -- Stops Yanky from leaking 'd' history into the OS
      },
    })
    
    pcall(function()
      require("telescope").load_extension("yank_history")
    end)
  end,
}
