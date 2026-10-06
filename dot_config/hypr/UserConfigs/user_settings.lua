-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User settings overrides template.
-- Add your personal hl.config(...) values here.

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "pc105",
    kb_options = "",
    kb_rules = "",
    repeat_rate = 50,
    repeat_delay = 300,
    sensitivity = 0.45,
    numlock_by_default = true,
    left_handed = false,
    follow_mouse = 1,
    float_switch_override_focus = false,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      clickfinger_behavior = false,
      middle_button_emulation = false,
      tap_to_click = true,
      drag_lock = false,
    },
    touchdevice = {
      enabled = true,
    },
    tablet = {
      transform = 0,
      left_handed = 0,
    },
  },
})

hl.config({
  xwayland = {
    enabled = false,
    force_zero_scaling = false,
  },
})

-- Intel i5-12450H iGPU & 60FPS Display Optimizations
hl.config({
  render = {
    direct_scanout = 2, -- bypass compositor rendering for fullscreen apps/videos
  },
  misc = {
    vrr = 0,            -- fixed 60Hz monitor
    enable_swallow = true,           -- unmap terminal when spawning GUI tools
    swallow_regex = "^(foot|footclient|kitty|ghostty)$",
    mouse_move_enables_dpms = false, -- prevent desk vibrations from waking display
    key_press_enables_dpms = true,  -- wake display via keyboard
    close_special_on_empty = true,
  },
  cursor = {
    inactive_timeout = 3,         -- hide cursor after 3s of inactivity
    hide_on_key_press = true,     -- hide cursor while typing
  },
})

-- Example:
-- hl.config({
--   general = {
--     gaps_in = 4,
--     gaps_out = 8,
--     border_size = 1,
--   },
-- })
--

-- Disable cursor being centered when swap workspaces
--
-- hl.config({
-- 	cursor = {
-- 		no_warps = true,
-- 		warp_on_change_workspace = 0,
-- 	},
-- })
