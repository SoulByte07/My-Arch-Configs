-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- Auto-generated from config/hypr/configs/LayerRules.conf for Lua testing.
-- Edit the source LayerRules.conf and regenerate this file when vendor rules change.

local function apply_layer_rule(rule)
  if hl.layer_rule then
    hl.layer_rule(rule)
  end
end

apply_layer_rule({
  name = "layerrule-001",
  match = {
    namespace = "rofi",
  },
  animation = "slide",
})

apply_layer_rule({
  name = "layerrule-002",
  match = {
    namespace = "notifications",
  },
  animation = "slide",
})
