-- lua/plugins/surround.lua
return {
    "kylechui/nvim-surround",
    version = "*",
    keys = { "ys", "ds", "cs" }, 
    config = function()
        require("nvim-surround").setup({
        })
    end,
}
