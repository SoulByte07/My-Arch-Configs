-- File: lua/plugins/copilot_chat.lua
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- The engine
      { "nvim-lua/plenary.nvim" },  -- Logic library
    },
    build = "make tiktoken",        -- Build tiktoken for better performance
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Ensure proper rendering in chat buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "n"
        end,
      })
    end,
    opts = {
      window = {
        layout = 'vertical',       -- Opens on the right side
        width = 0.4,               -- 40% of screen width
      },
      show_user_selection = false, -- Hides the UUID in user header
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatOpen<cr>",    desc = "Chat - Open" },
      { "<leader>ct", "<cmd>CopilotChatToggle<cr>",  desc = "Chat - Toggle" },
    },
  },
}
