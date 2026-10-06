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
    -- Catppuccin Tmux-Style Palette
    local orange = "#fab387" -- Active accent
    local mauve  = "#cba6f7" -- Inactive accent
    local num_bg = "#1e1e2e" -- Catppuccin Mocha Base background
    local dark   = "#181825"

    -- Active Two-Tone Pill: [ number ][ filename ]
    vim.api.nvim_set_hl(0, "TmuxPinActiveCapL", { fg = num_bg, bg = "NONE" })
    vim.api.nvim_set_hl(0, "TmuxPinActiveNum",  { bg = num_bg, fg = orange, bold = true })
    vim.api.nvim_set_hl(0, "TmuxPinActiveText", { bg = orange, fg = dark, bold = true })
    vim.api.nvim_set_hl(0, "TmuxPinActiveCapR", { fg = orange, bg = "NONE" })

    -- Inactive Two-Tone Pill: [ number ][ filename ]
    vim.api.nvim_set_hl(0, "TmuxPinInactiveCapL", { fg = num_bg, bg = "NONE" })
    vim.api.nvim_set_hl(0, "TmuxPinInactiveNum",  { bg = num_bg, fg = mauve, bold = true })
    vim.api.nvim_set_hl(0, "TmuxPinInactiveText", { bg = mauve, fg = dark, bold = true })
    vim.api.nvim_set_hl(0, "TmuxPinInactiveCapR", { fg = mauve, bg = "NONE" })

    -- Mode Colors
    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { bg = "#cba6f7", fg = "#1e1e2e", bold = true })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { bg = "#a6d189", fg = "#1e1e2e", bold = true })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { bg = "#f4b8e4", fg = "#1e1e2e", bold = true })

    -- Pre-calculate static Pill edge highlights once (Prevents TUI cell cache invalidation during redraws)
    local function setup_pill_highlights()
      local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
      local parent_bg = statusline_hl.bg and string.format("#%06x", statusline_hl.bg) or "NONE"
      local groups = {
        "MiniStatuslineModeNormal",
        "MiniStatuslineModeInsert",
        "MiniStatuslineModeVisual",
        "MiniStatuslineFilename",
        "MiniStatuslineFileinfo",
      }
      for _, grp in ipairs(groups) do
        local hl_info = vim.api.nvim_get_hl(0, { name = grp, link = false })
        local bg_color = hl_info.bg and string.format("#%06x", hl_info.bg) or "NONE"
        vim.api.nvim_set_hl(0, grp .. "Edge", { fg = bg_color, bg = parent_bg })
      end
    end
    setup_pill_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_pill_highlights })

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

    -- Dynamic Harpoon Pins from mini.visits (Zero Polling, Tmux Catppuccin Two-Tone Style)
    local function section_harpoon_pins()
      local pins = nil
      if _G.HarpoonPins and _G.HarpoonPins.get then
        pins = _G.HarpoonPins.get()
      else
        pcall(function() require("lazy").load({ plugins = { "mini.visits" } }) end)
        pins = _G.HarpoonPins and _G.HarpoonPins.get and _G.HarpoonPins.get() or {}
      end

      local current_path = vim.api.nvim_buf_get_name(0)
      local bubbles = {}

      for i = 1, 5 do
        local path = pins[i]
        if path then
          local fname = vim.fn.fnamemodify(path, ":t")
          local is_active = (path == current_path)
          local prefix = is_active and "TmuxPinActive" or "TmuxPinInactive"

          -- Two-tone pill: [ number ][ filename ]
          local bubble = string.format(
            "%%#%sCapL#%%#%sNum# %d %%#%sText# %s %%#%sCapR#",
            prefix, prefix, i, prefix, fname, prefix
          )
          table.insert(bubbles, bubble)
        end
      end

      if #bubbles == 0 then return "" end
      return table.concat(bubbles, " ")
    end

    local function section_diagnostics()
      local counts = vim.diagnostic.count(0)
      local errors = counts[vim.diagnostic.severity.ERROR] or 0
      local warnings = counts[vim.diagnostic.severity.WARN] or 0
      if errors == 0 and warnings == 0 then return "" end
      local parts = {}
      if errors > 0 then table.insert(parts, "✖ " .. errors) end
      if warnings > 0 then table.insert(parts, " " .. warnings) end
      return table.concat(parts, " ")
    end

    -- Zero-Mutation Pill Generator (Pre-calculated static highlights)
    local function make_pill(text, hl_group)
      if text == nil or text == "" then return "" end
      local edge_hl = hl_group .. "Edge"
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

          local filename      = section_filename_only()
          local harpoon_pins  = section_harpoon_pins()
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
            { strings = { harpoon_pins } },
            -- Middle Side 
            { hl = "MiniStatuslineNoice",   strings = { noice_mode } },
            { hl = "MiniStatuslinePending", strings = { pending } },

            -- Alignment spacer 
            "%=",

            -- Right Side 
            { strings = { make_pill(section_diagnostics(), "MiniStatuslineFileinfo") } },
            { strings = { make_pill(search, "MiniStatuslineFileinfo") } },
            { strings = { right_compact } },
          })
        end,
      },
    })

    vim.opt.laststatus = 3
  end,
}
