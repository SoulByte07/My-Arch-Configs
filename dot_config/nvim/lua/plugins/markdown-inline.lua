return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown' },
        cmd = { 'RenderMarkdown' },
        dependencies = { 
            'nvim-treesitter/nvim-treesitter', 
            'echasnovski/mini.icons',
        },
        opts = {
            anti_conceal = { enabled = true },
            enabled = true,
            file_types = { 'markdown' },
            html = { enabled = false },
            latex = { enabled = false },
            yaml = { enabled = false },
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
