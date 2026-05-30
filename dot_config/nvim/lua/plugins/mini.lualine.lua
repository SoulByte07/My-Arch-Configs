-- File: lua/plugins/mini-statusline.lua

return {
  "nvim-mini/mini.statusline",
  version = false,
  event = "VeryLazy",
  config = function()
    local statusline = require("mini.statusline")

    -- Custom Highlights
    vim.api.nvim_set_hl(0, "MiniStatuslineNoice", { fg = "#ff9e64", bold = true })
    vim.api.nvim_set_hl(0, "MiniStatuslinePending", { fg = "#cba6f7", bold = true })

    -- Mode Colors
    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { bg = "#cba6f7", fg = "#1e1e2e", bold = true })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { bg = "#a6d189", fg = "#1e1e2e", bold = true })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { bg = "#f4b8e4", fg = "#1e1e2e", bold = true })

    -- Helper Functions
    local function section_noice_mode()
      local ok, noice = pcall(require, "noice")
      if ok and noice.api.statusline.mode.has() then
        return noice.api.statusline.mode.get()
      end
      return ""
    end

    local function section_progress()
      local line = vim.fn.line(".")
      local total = vim.fn.line("$")
      if total <= 0 then return "0%%" end
      return string.format("%d%%%%", math.floor((line / total) * 100))
    end

    local function trim(s)
      return (s:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    -- Custom Filename Extractor (Tail Only)
    local function section_filename_only()
      local name = vim.fn.expand("%:t") -- '%:t' extracts just the tail (filename)
      if name == "" then return "[No Name]" end
      
      -- Append state flags naturally
      local modified = vim.bo.modified and " [+]" or ""
      local readonly = vim.bo.readonly and " [RO]" or ""
      
      return name .. modified .. readonly
    end

    -- Dynamic Pill Generator
    local function make_pill(text, hl_group)
      if text == nil or text == "" then return "" end
      local edge_hl = hl_group .. "Edge"
      local hl_info = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
      local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
      
      local bg_color = hl_info.bg and string.format("#%06x", hl_info.bg) or "NONE"
      local parent_bg = statusline_hl.bg and string.format("#%06x", statusline_hl.bg) or "NONE"
      
      vim.api.nvim_set_hl(0, edge_hl, { fg = bg_color, bg = parent_bg })
      return string.format("%%#%s#%%#%s# %s %%#%s#", edge_hl, hl_group, text, edge_hl)
    end

    -- Main Configuration
    statusline.setup({
      use_icons = true,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          
          if mode ~= "" then
             mode = " " .. string.upper(trim(mode))
          end

          -- Use our new custom filename function instead of mini's default
          local filename      = section_filename_only()
          
          local noice_mode    = section_noice_mode()
          local pending       = "%S"
          local progress      = section_progress()
          local location      = "%l:%v"
          local search        = statusline.section_searchcount({ trunc_width = 75 })
          local left_compact  = make_pill(mode, mode_hl) .. make_pill(filename, "MiniStatuslineFilename")
          local right_compact = make_pill(progress, "MiniStatuslineFileinfo") .. make_pill(location, mode_hl)

          return statusline.combine_groups({
            -- Left Side
            { strings = { left_compact } },
            
            -- Middle Side 
            { hl = "MiniStatuslineNoice",   strings = { noice_mode } },
            { hl = "MiniStatuslinePending", strings = { pending } },

            -- Alignment spacer 
            "%=",

            -- Right Side 
            { strings = { make_pill(search, "MiniStatuslineFileinfo") } },
            { strings = { right_compact } },
          })
        end,
      },
    })

    vim.opt.laststatus = 3
  end,
}
