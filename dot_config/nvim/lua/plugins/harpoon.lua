-- File: lua/plugins/harpoon.lua

return {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  keys = {
    -- 1. Custom "Bouncer" Add Function
    {
      "<leader>a",
      function()
        local mark = require("harpoon.mark")
        local count = mark.get_length()

        if count >= 5 then
          -- Notify the user that the "VIP list" is full
          vim.notify("Harpoon Full (5/5)! Remove a file to add more.", vim.log.levels.WARN)
        else
          mark.add_file()
          -- Optional: Show current count after adding
          vim.notify("File Marked: " .. (count + 1) .. "/5", vim.log.levels.INFO)
        end
      end,
      desc = "Harpoon Mark (Max 5)"
    },

    -- 2. Menu and Navigation
    { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
    { "<C-1>", function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon 1" },
    { "<C-2>", function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon 2" },
    { "<C-3>", function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon 3" },
    { "<C-4>", function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon 4" },
    { "<C-5>", function() require("harpoon.ui").nav_file(5) end,         desc = "Harpoon 5" },
  },
}
