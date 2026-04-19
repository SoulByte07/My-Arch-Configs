-- File: ~/.config/nvim/lua/plugins/markdown.lua

return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        format = 'markdown',
        -- event = 'BufReadPre',
        -- lazy = true,
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            -- This handles your Normal/Insert mode request automatically
            anti_conceal = {
                enabled = true,
            },
            -- Renders only on markdown files
            enabled = true,
            file_types = { 'markdown' },
            -- Visual tweaks to make it "pretty"
            heading = {
                sign = true,
                icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            },
            bullet = {
                icons = { '●', '○', '◆', '◇' },
            },
        },
    },
}

