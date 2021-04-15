local gfs = require("gears.filesystem")
local dpi = require("beautiful.xresources").apply_dpi
local cairo = require("lgi").cairo

local theme = dofile(gfs.get_themes_dir() .. "gtk/theme.lua")

-- Disable that annoying clock cursor
theme.enable_spawn_cursor = false

theme.font = "serif 11.5"
theme.border_width = dpi(2)

theme.titlebar_bg_focus = {
   type		= "linear",
   from		= { 10, 0 },
   to		= { 10, 40 },
   stops	= { { 0.05, theme.titlebar_bg_focus }, { 0.86, "#1c1b1e" } },
}

theme.titlebar_bg_normal = {
   type		= "linear",
   from		= { 10, 0 },
   to		= { 10, 40 },
   stops	= { { 0.0, "#ffffff" }, { 0.86, theme.titlebar_bg_normal } },
}

return theme
