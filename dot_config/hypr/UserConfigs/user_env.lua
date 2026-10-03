-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User environment overrides.
-- Keep this file for personal env additions that should survive updates.

-- For Electron apps (VS Code, Discord, etc.)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- For Chromium/Chrome specifically (some versions respect this)
hl.env("CHROME_OZONE_PLATFORM_HINT", "wayland")

-- Forces the ozone platform for anything that looks for it
hl.env("OZONE_PLATFORM", "wayland")

-- Examples:
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("GDK_SCALE", "1")
-- hl.env("QT_SCALE_FACTOR", "1")
-- hl.env("WEATHER_UNITS", "metric")
