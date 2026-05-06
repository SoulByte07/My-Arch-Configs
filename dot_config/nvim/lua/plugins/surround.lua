-- lua/plugins/surround.lua
return {
    "kylechui/nvim-surround",
    version = "*",
    -- The plugin only loads when you press one of these keys
    keys = { "ys", "ds", "cs" }, 
    config = function()
        require("nvim-surround").setup({
            -- Standard configuration
        })
    end,
}
