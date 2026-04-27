return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 
            { 
                'nvim-treesitter/nvim-treesitter', 
                branch = 'master',
                build = ':TSUpdate', 
                config = function()
                    require('nvim-treesitter').setup({
                        ensure_installed = { "markdown", "markdown_inline" },
                        
                        highlight = { enable =  true}, 
                        
                        indent = { enable =  true},
                    })
                end
            }, 
            'nvim-tree/nvim-web-devicons' 
        },
        opts = {
            anti_conceal = { enabled = true },
            enabled = true,
            file_types = { 'markdown' },
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
