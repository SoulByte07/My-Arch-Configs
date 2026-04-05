if vim.loader then
  vim.loader.enable()
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("vim-options")
require("lazy").setup("plugins")

-- Test: Force all plugins to load immediately (for testing purposes)
-- require("lazy").setup(plugins, {
--   defaults = { lazy = false }, -- This forces everything to load immediately
-- })
