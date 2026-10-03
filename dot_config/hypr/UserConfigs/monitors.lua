-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- User monitor overrides for Lua workflow.
-- MonitorProfiles.sh writes selected Lua monitor profiles into this file.
-- Keep custom hl.monitor(...) entries here so upgrades preserve them.

-- Example:
-- hl.monitor({
--     output = "eDP-1",
--     mode = "preferred",
--     position = "auto",
--     scale = "1",
-- })

-- 15.6" 1920x1080 eDP panel. The session was landing on 1.5 (1280x720
-- logical), which renders every client oversized. 1.25 gives 1536x864.
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = "1.0",
})
