-- File: nvim/lua/vim-options.lua

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "
vim.opt.background = "dark"

vim.opt.swapfile = false
vim.opt.clipboard = "" -- Keep isolated so deletes (dd, x, c) never overwrite OS clipboard

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
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.splitkeep = "screen"
vim.opt.confirm = true
vim.opt.inccommand = "split"

-- Persistent undo
local undodir = vim.fn.expand("~/.local/share/nvim/undo//")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 1000

-- Display options
vim.opt.scrolloff = 999
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.showcmdloc = "statusline"
vim.opt.winbar = " "
vim.opt.cursorline = true
vim.opt.pumheight = 10

-- Command-line completion popup settings
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- Native Zero-Overhead Indent Guides (Neovim 0.10+ / 0.12)
vim.opt.list = true
vim.opt.listchars = {
  leadmultispace = "│   ",
  tab = "│ ",
  trail = "·",
}
vim.api.nvim_set_hl(0, "Whitespace", { fg = "#45475a" })

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

-- Native Large File Performance Safeguard (files > 1.5 MB)
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = vim.api.nvim_create_augroup("BigFileDisable", { clear = true }),
  callback = function(args)
    local ok, stat = pcall(vim.uv.fs_stat, args.match)
    if ok and stat and stat.size > 1.5 * 1024 * 1024 then
      vim.b[args.buf].bigfile = true
      vim.opt_local.undolevels = -1
      vim.opt_local.swapfile = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.syntax = "off"
      vim.opt_local.wrap = false
    end
  end,
})
