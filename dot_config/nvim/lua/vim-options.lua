vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Remap 'e' to go to the end of the line in Normal and Visual modes
vim.keymap.set({ 'n', 'x' }, 'e', '$', { noremap = true, silent = true, desc = "Go to end of line" })
vim.keymap.set({ 'v', 'x' }, 'e', '$', { noremap = true, silent = true, desc = "Go to end of line" })


vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear Highlights' })
vim.opt.number = true
vim.opt.relativenumber = true

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0


-- primagen
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Native Neovim 0.10 Commenting
vim.keymap.set("n", "cc", "gcc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("v", "cc", "gc", { remap = true, desc = "Toggle Comment" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- filetype detection for certain filetypes
local ft_fix_group = vim.api.nvim_create_augroup("EfficientFTFix", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = ft_fix_group,
    callback = function()
        if vim.bo.filetype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("filetype detect")
        end
    end,
})


-- Enable persistent undo
local undodir = vim.fn.expand("~/.local/share/nvim/undo//")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true


-- Typewriter Mode Toggle
vim.opt.scrolloff = 999


-- Remap Visual Block Mode to Leader + v
vim.keymap.set("n", "<leader>v", "<C-v>", { desc = "Visual Block Mode" })

-- Standard Neovim options for case-insensitive searching
vim.opt.ignorecase = true -- Don't care about case by default
vim.opt.smartcase = true  -- Switch to case-sensitive if I type a Capital letter

-- noice.lua
vim.opt.showcmd = true            -- Enable showing keystrokes
vim.opt.showcmdloc = "statusline"

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

-- YAML LSP warnings for specific filetypes
vim.filetype.add({
  pattern = {
    ["docker-compose%.yml"] = "yaml.docker-compose",
    ["docker-compose%.yaml"] = "yaml.docker-compose",
    ["gitlab-ci%.yml"] = "yaml.gitlab",
    ["values%.yaml"] = "yaml.helm-values",
  },
})
