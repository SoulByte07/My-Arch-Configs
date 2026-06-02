-- File: nvim/lua/keymaps.lua

local opts = { noremap = true, silent = true }

-- Navigation between splits
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Vertical split
vim.keymap.set('n', '<C-S>', '<C-w>v', opts)

-- Remove search highlights
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear Highlights' })

-- Go to end of line
vim.keymap.set({ 'n', 'x' }, 'e', '$', { noremap = true, silent = true, desc = "Go to end of line" })
vim.keymap.set({ 'v', 'x' }, 'e', '$', { noremap = true, silent = true, desc = "Go to end of line" })

-- Move selected lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Center cursor on half-page scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center cursor on search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
-- Search and replace the selected string
vim.keymap.set("v", "<leader>s", [[y:%s/<C-r>"/<C-r>"/gc<Left><Left><Left>]])

-- Native Neovim 0.10 Commenting
vim.keymap.set("n", "cc", "gcc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("v", "cc", "gc", { remap = true, desc = "Toggle Comment" })

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Visual Block Mode
vim.keymap.set("n", "<leader>v", "<C-v>", { desc = "Visual Block Mode" })
