vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("syntax enable")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Comments
-- vim.keymap.set("n", "cc", "gcc", { remap = true, desc = "Comment: Toggle line" })
-- vim.keymap.set("v", "cc", "gc", { remap = true, desc = "Comment: Toggle selection" })


-- spider-horizontal movement
vim.keymap.set({ "n", "o", "x" }, "w", function()
	require("spider").motion("w")
end, { desc = "Spider-w" })

vim.keymap.set({ "n", "o", "x" }, "e", function()
	require("spider").motion("e")
end, { desc = "Spider-e" })

vim.keymap.set({ "n", "o", "x" }, "b", function()
	require("spider").motion("b")
end, { desc = "Spider-b" })



vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear Highlights' })
vim.wo.number = true
vim.wo.relativenumber = true

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0



-- Enable persistent undo
local undodir = vim.fn.expand("~/.local/share/nvim/undo//")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true


-- indentline
-- vim.opt.list = true
-- vim.opt.listchars = {
--   tab = "│ ",
--   multispace = " ",     
--   leadmultispace = "│   ", -- Renders the indent line for space-indented code
--   trail = " ",           -- Shows trailing spaces at end of line
--   nbsp = "␣",            -- Shows non-breaking spaces
-- }


-- Typewriter Mode Toggle
vim.opt.scrolloff = 999

-- Remap Visual Block Mode to Leader + v
vim.keymap.set("n", "<leader>v", "<C-v>", { desc = "Visual Block Mode" })

-- Standard Neovim options for case-insensitive searching
vim.opt.ignorecase = true -- Don't care about case by default
vim.opt.smartcase = true  -- Switch to case-sensitive if I type a Capital letter

-- noice.lua
vim.opt.showcmd = true            -- Enable showing keystrokes
vim.opt.showcmdloc = "statusline" -- Crucial: Route them to the statusline

-- Buffer line
vim.opt.winbar = " "

vim.opt.cursorline = true

-- Disable unnecessary built-in plugins
local disabled_built_ins = {
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
  "2html_plugin", "logipat", "rrhelper", "spellfile_plugin", "tutor"
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Shada file settings
vim.opt.shada = "!,'100,<50,s10,h"
