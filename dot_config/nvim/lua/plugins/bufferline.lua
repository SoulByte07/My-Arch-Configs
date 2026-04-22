-- File: lua/plugins/bufferline.lua
-- Sample Input: Open Neovim with 3 files pinned via mini.visits
-- Expected Output: Bufferline displays only those 3 files, prefixed with "1: ", "2: ", etc.

return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    -- 1. Swap Harpoon for mini.visits dependency
    dependencies = { "catppuccin", "nvim-mini/mini.visits" },
    
    opts = function(_, opts)
      local get_name = vim.api.nvim_buf_get_name

      -- 2. HIGH-PERFORMANCE CACHE
      -- Prevents UI lag by limiting how often we query mini.visits during renders
      local pin_cache = {}
      local last_update = 0

      local function get_pins()
        local now = vim.loop.now()
        -- Return cached data if less than 200ms has passed
        if now - last_update < 200 then return pin_cache end
        
        local visits = require("mini.visits")
        local cwd = vim.fn.getcwd()
        pin_cache = {}
        last_update = now

        for i = 1, 5 do
          local paths = visits.list_paths(cwd, {
            filter = function(p) 
              return type(p.labels) == "table" and p.labels["harpoon_" .. i] 
            end
          })
          -- If a path exists for this slot, cache it
          if paths[1] then
            pin_cache[paths[1]] = i
          end
        end
        
        return pin_cache
      end

      -- 3. THEME INTEGRATION
      local status, catppuccin_hl = pcall(require, "catppuccin.groups.integrations.bufferline")
      if status then opts.highlights = catppuccin_hl.get() end

      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.separator_style = "thin"
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false

      -- 4. OPTIMIZED FILTER: Only allow buffers that exist in our mini.visits cache
      opts.options.custom_filter = function(buf_id)
        local b_path = get_name(buf_id)
        local pins = get_pins()
        return pins[b_path] ~= nil
      end

      -- 5. OPTIMIZED FORMATTER: Prefix the buffer name with its mini.visits slot
      opts.options.name_formatter = function(buf)
        local pins = get_pins()
        local slot = pins[buf.path]
        if slot then
          return slot .. ": " .. buf.name
        end
        return buf.name
      end
    end,

    config = function(_, opts)
      require("bufferline").setup(opts)

      -- 6. LOW-OVERHEAD STARTUP INJECTION
      -- Force the pinned files to load into buffers on startup so the UI populates
      vim.schedule(function()
        local visits = require("mini.visits")
        local cwd = vim.fn.getcwd()
        local bufadd = vim.fn.bufadd

        for i = 1, 5 do
          local paths = visits.list_paths(cwd, {
            filter = function(p) 
              return type(p.labels) == "table" and p.labels["harpoon_" .. i] 
            end
          })
          
          local file = paths[1]
          if file and file ~= "" then
            local buf = bufadd(file)
            if not vim.bo[buf].buflisted then
              vim.bo[buf].buflisted = true
            end
          end
        end
      end)
    end,
  },
}
