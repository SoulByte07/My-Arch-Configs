-- File: ~/.config/nvim/lua/plugins/trouble.lua

require("trouble").setup({
  -- You can leave the default settings or customize icons here
})

-- Set up handy shortcuts
local opts = { silent = true, noremap = true }

-- See everything in the project (your specific request)
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics show<cr>", opts)

-- See only errors in the current file
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)

-- Close any open trouble windows
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble close<cr>", opts)
