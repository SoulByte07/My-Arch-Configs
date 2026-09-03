-- File: lua/plugins/visits.lua

return {
  "nvim-mini/mini.visits",
  version = false,
  event = "VeryLazy",
  config = function()
    local visits = require("mini.visits")
    visits.setup()

    local max_slots = 5 -- Strictly set to 5 to match Harpoon

    local function slot_label(i)
      return "harpoon_" .. i
    end

    local function has_label(path_data, label)
      return type(path_data.labels) == "table" and path_data.labels[label] == true
    end

    local function get_slot_path(i)
      local label = slot_label(i)
      local paths = visits.list_paths(vim.fn.getcwd(), {
        filter = function(path_data)
          return has_label(path_data, label)
        end,
      })
      return paths[1]
    end

    local function find_slot_by_path(path)
      for i = 1, max_slots do
        if get_slot_path(i) == path then return i end
      end
      return nil
    end

    -- Core Logic: Add or Remove
    local function toggle_pin()
      local path = vim.api.nvim_buf_get_name(0)
      if path == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
      end

      local current_slot = find_slot_by_path(path)

      -- 1. If already pinned, unpin it to free up space
      if current_slot then
        visits.remove_label(slot_label(current_slot), path, vim.fn.getcwd())
        vim.notify("Removed from Harpoon slot " .. current_slot, vim.log.levels.INFO)
        return
      end

      -- 2. Find an empty slot and count current pins
      local target_slot = nil
      local current_count = 0
      
      for i = 1, max_slots do
        if get_slot_path(i) then
          current_count = current_count + 1
        elseif not target_slot then
          target_slot = i
        end
      end

      -- 3. Bouncer check
      if not target_slot then
        vim.notify("Harpoon Full (5/5)! Remove a file to add more.", vim.log.levels.WARN)
        return
      end

      -- 4. Mark the file
      local label = slot_label(target_slot)
      visits.add_label(label, path, vim.fn.getcwd())
      vim.notify("File Marked: " .. (current_count + 1) .. "/5 (Slot " .. target_slot .. ")", vim.log.levels.INFO)
    end

    -- Navigation Logic
    local function nav_slot(i)
      local path = get_slot_path(i)
      if not path then
        vim.notify("Harpoon " .. i .. " is empty", vim.log.levels.WARN)
        return
      end
      vim.cmd.edit(vim.fn.fnameescape(path))
    end

    -- UI Menu
    local function toggle_quick_menu()
      local items = {}
      for i = 1, max_slots do
        local path = get_slot_path(i)
        local display_path = path and vim.fn.fnamemodify(path, ":~:.") or "<empty>"
        items[#items + 1] = {
          slot = i,
          text = string.format("[%d] %s", i, display_path),
        }
      end

      vim.ui.select(items, {
        prompt = "Pined Buffers",
        format_item = function(item) return item.text end,
      }, function(choice)
        if choice then nav_slot(choice.slot) end
      end)
    end

    -- Keymaps
    vim.keymap.set("n", "<leader>a", toggle_pin, { desc = "Harpoon Mark/Unmark" })
    vim.keymap.set("n", "<C-e>", toggle_quick_menu, { desc = "Harpoon Menu" })
    
    -- Dynamically generate C-1 through C-5 keymaps
    for i = 1, max_slots do
      vim.keymap.set("n", "<M-" .. i .. ">", function() nav_slot(i) end, { desc = "Harpoon " .. i })
    end
  end,
}
