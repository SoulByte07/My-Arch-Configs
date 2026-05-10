-- file: ~/.config/nvim/lua/treesitter.lua

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    configs.setup({
      ensure_installed = {
        "jsdoc", 
        "bash",
        "regex",
        "markdown",
        "markdown_inline",
        "go",
      },

      sync_install = false,
      auto_install = vim.fn.executable("tree-sitter") == 1,
      indent = { enable = true },
      highlight = {
        enable = true,
        -- additional_vim_regex_highlighting = { "markdown" },
        additional_vim_regex_highlighting = false,
      },
    })

    -- ... (Keep your existing templ parser config down here) ...
    local parser_ok, parser_config = pcall(require, "nvim-treesitter.parsers")
    if not parser_ok then
      return
    end

    local treesitter_parser_config = parser_config.get_parser_configs()
    treesitter_parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        -- branch = "master",
      },
    }

    pcall(vim.treesitter.language.register, "templ", "templ")
  end,
}
