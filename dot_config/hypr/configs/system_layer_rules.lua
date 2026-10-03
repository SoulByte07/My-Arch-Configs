-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- System defaults migrated from configs/LayerRules.conf (auto-generated).
-- Add additional rules with apply_layer_rule({...}).
-- Example:
-- apply_layer_rule({
--   name = "My Layer Rule",
--   match = { namespace = "rofi" },
--   blur = true,
-- })

local function apply_layer_rule(rule)
  if hl.layer_rule then
    hl.layer_rule(rule)
  end
end

-- Converted from configs/LayerRules.conf
apply_layer_rule({
  name = "system-layer-layerrule-001",
  match = {
    namespace = "rofi",
  },
  animation = "slide",
})

apply_layer_rule({
  name = "system-layer-layerrule-002",
  match = {
    namespace = "notifications",
  },
  animation = "slide",
})

