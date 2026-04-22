-- File: ~/.config/nvim/lua/plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason", -- Lazy loads when you call the command
    -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason UI" } },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
