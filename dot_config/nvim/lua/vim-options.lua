-- File: nvim/lua/vim-options.lua

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Provider disabling
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- UI & Behavior
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Filetype detection
local ft_fix_group = vim.api.nvim_create_augroup("EfficientFTFix", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = ft_fix_group,
    callback = function()
        if vim.bo.filetype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("filetype detect")
        end
    end,
})

-- Persistent undo
local undodir = vim.fn.expand("~/.local/share/nvim/undo//")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Display options
vim.opt.scrolloff = 999
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.showcmdloc = "statusline"
vim.opt.winbar = " "
vim.opt.cursorline = true

-- Disable unnecessary built-in plugins
local disabled_built_ins = {
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
  "2html_plugin", "logipat", "rrhelper", "spellfile_plugin" 
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Shada file settings
vim.opt.shada = "!,'100,<50,s10,h"

-- Custom filetype patterns
vim.filetype.add({
  pattern = {
    ["docker-compose%.yml"] = "yaml.docker-compose",
    ["docker-compose%.yaml"] = "yaml.docker-compose",
    ["gitlab-ci%.yml"] = "yaml.gitlab",
    ["values%.yaml"] = "yaml.helm-values",
  },
})
