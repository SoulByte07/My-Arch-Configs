-- File: lua/plugins/visits.lua

return {
  "nvim-mini/mini.visits",
  version = false,
  event = "VeryLazy",
  config = function()
    local visits = require("mini.visits")
    visits.setup({ silent = true })

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

    _G.HarpoonPins = {
      cache = nil,
      cache_cwd = nil,
    }

    function _G.HarpoonPins.get()
      local cwd = vim.fn.getcwd()
      if _G.HarpoonPins.cache and _G.HarpoonPins.cache_cwd == cwd then
        return _G.HarpoonPins.cache
      end
      local pins = {}
      for i = 1, max_slots do
        local p = get_slot_path(i)
        if p then pins[i] = p end
      end
      _G.HarpoonPins.cache = pins
      _G.HarpoonPins.cache_cwd = cwd
      return pins
    end

    function _G.HarpoonPins.invalidate()
      _G.HarpoonPins.cache = nil
      vim.cmd.redrawstatus()
    end

    -- Recalculate & compact slot numbers (1..max_slots) to close any gaps
    local function recalculate_pins()
      local cwd = vim.fn.getcwd()
      local active_paths = {}

      -- 1. Gather all unique pinned paths in current slot order
      for i = 1, max_slots do
        local p = get_slot_path(i)
        if p and not vim.tbl_contains(active_paths, p) then
          table.insert(active_paths, p)
        end
      end

      -- 2. Strip all harpoon_1..max_slots labels in this cwd
      for i = 1, max_slots do
        local label = slot_label(i)
        local paths = visits.list_paths(cwd, {
          filter = function(path_data)
            return has_label(path_data, label)
          end,
        })
        for _, p in ipairs(paths) do
          visits.remove_label(label, p, cwd)
        end
      end

      -- 3. Re-assign labels sequentially without gaps
      for i, p in ipairs(active_paths) do
        if i <= max_slots then
          visits.add_label(slot_label(i), p, cwd)
        end
      end

      _G.HarpoonPins.invalidate()
    end

    _G.HarpoonPins.recalculate = recalculate_pins

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        if _G.HarpoonPins then
          _G.HarpoonPins.invalidate()
          pcall(recalculate_pins)
        end
      end,
    })

    -- Core Logic: Add or Remove
    local function toggle_pin()
      local path = vim.api.nvim_buf_get_name(0)
      if path == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
      end

      local current_slot = find_slot_by_path(path)

      -- 1. If already pinned, unpin it and recalculate slots
      if current_slot then
        visits.remove_label(slot_label(current_slot), path, vim.fn.getcwd())
        recalculate_pins()
        vim.notify("Unpinned file (slots recalculated)", vim.log.levels.INFO)
        return
      end

      -- 2. Count current pins
      local current_count = 0
      for i = 1, max_slots do
        if get_slot_path(i) then current_count = current_count + 1 end
      end

      -- 3. Bouncer check
      if current_count >= max_slots then
        vim.notify("Harpoon Full (5/5)! Remove a file to add more.", vim.log.levels.WARN)
        return
      end

      -- 4. Mark the file into the next sequential slot and recalculate
      local next_slot = current_count + 1
      visits.add_label(slot_label(next_slot), path, vim.fn.getcwd())
      recalculate_pins()
      vim.notify("File Marked: " .. next_slot .. "/5 (Slot " .. next_slot .. ")", vim.log.levels.INFO)
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
        prompt = "Pinned Buffers",
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

    -- Initial compaction on setup to clean up any legacy gaps
    pcall(recalculate_pins)
  end,
}
