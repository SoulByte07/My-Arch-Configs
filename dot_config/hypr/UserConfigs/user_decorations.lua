-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User decorations overrides.
-- Dynamically loads Wallust generated colors from wallust-hyprland.conf.

local home = os.getenv("HOME") or ""
local helper_path = home .. "/.config/hypr/lua/user_decorations_helper.lua"
local ok, helper = pcall(dofile, helper_path)
local wallust = (ok and helper and helper.load_wallust_colors)
  and helper.load_wallust_colors(home .. "/.config/hypr/wallust/wallust-hyprland.conf")
  or {}

local active_col = wallust.color12 or "rgba(8db4ffff)"
local inactive_col = wallust.color10 or "rgba(5f6578ff)"

hl.config({
  general = {
    border_size = 2,
    gaps_in = 2,
    gaps_out = 4,
    col = {
      active_border = active_col,
      inactive_border = inactive_col,
    },
  },
})

hl.config({
  decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    dim_inactive = false,
    dim_strength = 0.0,
    dim_special = 0.0,
    shadow = {
      enabled = false,
      range = 3,
      render_power = 1,
      color = active_col,
      color_inactive = inactive_col,
    },
    blur = {
      enabled = false,
      size = 6,
      passes = 2,
      new_optimizations = true,
      xray = false,
      ignore_opacity = true,
      special = true,
      popups = true,
    },
  },
})

hl.config({
  group = {
    col = {
      border_active = wallust.color15 or active_col,
    },
    groupbar = {
      blur = false,
      col = {
        active = wallust.color0 or "rgba(0f111aff)",
      },
    },
  },
})
