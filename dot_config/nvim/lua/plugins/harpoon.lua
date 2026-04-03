-- File: lua/plugins/harpoon.lua
-- Sample Input: Pressing `<leader>a` in a file to pin it, then pressing `<C-e>` to view pinned files.
-- Expected Output: A quick menu appears with your top files. Pressing Enter teleports you there.

return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Harpoon Mark" },
    { "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
  },
}
