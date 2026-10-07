-- lua/plugins/surround.lua
return {
    "kylechui/nvim-surround",
    version = "*",
    keys = {
        "ys", "ds", "cs",
        { "S", mode = "x", desc = "Surround visual selection" },
        { "gS", mode = "x", desc = "Surround visual selection (new lines)" },
    }, 
    config = function()
        require("nvim-surround").setup({
        })
    end,
}
