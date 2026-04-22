return {
  "nvim-mini/mini.indentscope",
  version = false,
  event = {"VeryLazy", "BufReadPre", "BufNewFile"},
  opts = {
    symbol = "│",
    options = { try_as_border = true },
  },
}
