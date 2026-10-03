-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User defaults overrides.
-- This file is sourced by lua/user_defaults.lua.

KOOLDOTS_DEFAULTS = KOOLDOTS_DEFAULTS or {}

-- Default text editor. The KooL Quick Settings menu (SUPER SHIFT E) reads this
-- value and falls back to nano when nothing is set.
local editor = os.getenv("EDITOR")
if editor == nil or editor == "" then
  editor = "nvim"
end
KOOLDOTS_DEFAULTS.edit = editor

-- Visual editor; empty is fine, $edit is preferred.
KOOLDOTS_DEFAULTS.visual = os.getenv("VISUAL") or ""

-- These two are also used by the waybar modules and user keybinds.
KOOLDOTS_DEFAULTS.term = "foot"
KOOLDOTS_DEFAULTS.files = "thunar"

-- Default search engine for the launcher search (SUPER S is overridden to
-- tools-manager in user_keybinds.lua; this is used by the search menus).
KOOLDOTS_DEFAULTS.search_engine = "https://www.brave.com/search?q={}"

-- Examples of other keys this table accepts:
-- KOOLDOTS_DEFAULTS.edit = "nvim"
-- KOOLDOTS_DEFAULTS.visual = "nvim"
-- KOOLDOTS_DEFAULTS.term = "kitty"
-- KOOLDOTS_DEFAULTS.files = "thunar"
-- KOOLDOTS_DEFAULTS.search_engine = "https://duckduckgo.com/?q={}"
