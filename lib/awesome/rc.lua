-- * The very basics

-- Seems like we need to call certain functions for awesome to run
-- properly. One of that includes loading the default theme file. So
-- we do that here.

local gears = require("gears")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local awful = require("awful")

-- ** Notify on buggy config

-- The notification library

local naughty = require("naughty")

-- This is just copy-paste from the default config with minor changes
-- lol.

if awesome.startup_errors then
   naughty.naughty({
		 preset = naughty.config.presets.critical,
		 title = "Awesome config has an error",
		 text = awesome.startup_errors,
   })
end

-- Also send notification on other errors

do
   local inerr = false
   awesome.connect_signal(
	  "debug::error",
	  function (e)
		 if inerr then return end
		 inerr = true
		 naughty.notify({
			   preset = naughty.config.presets.critical,
			   title = "An error in config",
			   text = tostring(e),
		 })
		 inerr = false
   end)
end

-- ** Clear off the keybinds already set

globalkeys = {}

-- * Wallpaper

-- gears.wallpaper does not have a zoom mode which I use the most
-- often!

local cairo = require("lgi").cairo

function vz_wallpaper_zoom (surf, s, background)
   local geom, cr = gears.wallpaper.prepare_context(s)
   local origsurf = surf
   surf = gears.surface.load_uncached(surf)
   background = gears.color(background)

   cr.operator = cairo.Operator.SOURCE
   cr.source = background
   cr:paint()

   local w_i, h_i = gears.surface.get_size(surf)
   local nw, nh = 0, 0
   if (w_i / h_i) > (geom.width / geom.height) then
	  nw = w_i * geom.height / h_i
	  nh = geom.height
   else
	  nw = geom.width
	  nh = h_i * geom.width / w_i
   end

   cr:translate((geom.width - nw)/2, (geom.height - nh)/2)
   cr:rectangle(0, 0, nw, mw)
   cr:scale(nw/w_i, nh/h_i)

   cr:set_source_surface(surf, 0, 0)
   cr:paint()
   if surf ~= origsurf then
	  surf:finish()
   end
   if cr.status ~= "SUCCESS" then
	  gears.debug.print_warning("Cairo context entered error state: " .. cr.status)
   end
end

-- I have a script that will call `bgs` to set the wallpaper. And that
-- script saves the command to call to set the wallpaper in a
-- wallpaper. The script stores the path as the second argument. So if
-- that file exists, we will read it and set the wallpaper
-- accordingly!

do
   local path = gears.filesystem.get_xdg_cache_home() .. "wall"
   local wallpaper = {}
   if gears.filesystem.file_readable(path) then
	  for i in io.lines(path) do
		 if i then
			for j in string.gmatch(i, "%S+") do
			   table.insert(wallpaper, j)
			end
			break
		 end
	  end
	  local mode = gears.wallpaper.fit
	  local bg = "#000000"

	  -- Set the path to wallpaper
	  beautiful.wallpaper = wallpaper[2]

	  -- How to set the wallpaper can be determined from the rest of
	  -- the flags

	  for i,f in pairs(wallpaper) do
		 if f == "-C" then
			bg = wallpaper[i+1]
		 end

		 -- c: centre
		 -- z: zoom
		 -- t: tile
		 if f == "-c" then
			mode = gears.wallpaper.centered
			break
		 elseif f == "-z" then
			mode = vz_wallpaper_zoom
			break
		 elseif f == "-t" then
			mode = gears.wallpaper.tiled
			break
		 end
	  end

	  awful.screen.connect_for_each_screen(function (s)
			if mode ~= gears.wallpaper.tiled then
			   mode(beautiful.wallpaper, s, bg)
			else
			   mode(beautiful.wallpaper, s)
			end
	  end)
   end
end

-- * Terminal and editor

-- I use emacs, for both

terminal = "eterm || st"
editor = "emacsclient"
editor_cmd = editor .. "-ca''"

globalkeys = {
   awful.key(
	  { modkey, "Shift" }, "Return",
	  function () awful.span(terminal) end,
	  { description = "Spawn M-x shell or st if Emacs daemon is not running", group = "launcher" }),
   awful.key(
	  { modkey }, "e",
	  function () awful.span(editor_cmd) end,
	  { description = "Spawn emacsclient or start an Emacs session", group = "launcher" })
}


-- * Layouts

-- I don't find tiling useful™

awful.layout.layouts = {
   awful.layout.suit.floating,
}

-- * Tags

-- My first wm was dwm and I was spoiled by its tags system after
-- using it for a long time. I switched to awesome because of tags and
-- lua config. So yea....

awful.screen.connect_for_each_screen(function (s)
	  awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
end)

for i=1,10 do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key(
		 { modkey },
		 "#"..i+9,
		 function ()
			local tag = awful.screen.focused().tags[i]
			if tag then tag:view_only() end
		 end,
		 { description = "Switch to tag #"..i, group = "tag" }),
	  awful.key(
		 { modkey, "Control" },
		 "#"..i+9,
		 function ()
			local tag = awful.screen.focused().tags[i]
			if tag then awful.tag.viewtoggle(tag) end
		 end,
		 { description = "Toggle tag #"..i, group = "tag" }),
	  awful.key(
		 { modkey, "Shift" },
		 "#"..i+9,
		 function ()
			if client.focus then
			   local tag = client.focus.screen.tags[i]
			   if tag then client.focus:move_to_tag(tag) end
			end
		 end,
		 { description = "Move focused window to tag #"..i, group = "tag" }))
end

-- * Keybinds
-- ** Window size and shape

-- I am an epic gamer and use wasd for moving and resizing windows. No
-- joke though, they are actually good

for d,c in pairs({ w = { 0, -50 }, s = { 50, 0 },
				   a = { -50, 0 }, d = { 0, -50 } }) do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key(
		 { modkey }, d,
		 function ()
			if client.focus then
			   client.focus.moveresize(c[1], c[2])
			end
	  end),
	  awful.key(
		 { modkey, "Shift" }, d,
		 function ()
			if client.focus then
			   client.focus.moveresize(0, 0, c[1], c[2])
			end
   end))
end

-- ** Window focus

-- Directional focus is the only sane option!

for k,d in pairs({ h = "left", j = "down",
				   k = "up", l = "right" }) do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key({ modkey, "Control" }, k, function () awful.client.focus.bydirection(d) end))
end

-- Sometimes I lose focus and flashing the window border can
-- help. SEIZURE WARNING! btw

local vz_flashfocus = false

-- globalkeys = gears.table.join(
   -- globalkeys,
   -- awful.key({ modkey, "Shift" }, "f",
	  -- function ()
		 -- if vz_flashfocus then
		 -- end
	  -- end,
	  -- { description = "Flash the border of focused client" }))

-- ** Awesome independent commands

-- These are with just modkey modifier
for k,c in pairs({
	  Print = "screenshot -u",
	  v = "chromium",
	  l = "slock",
	  m = "mus",
	  -- p = "wmenu",
}) do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key({ modkey }, k, function () awful.spawn(c) end))
end

-- These are with shift modifier
for k,c in pairs({
	  x = "turnoff",
	  r = "pkill -USR1 redshift",
	  -- f = "flashfocus",
	  k = "vol -i 1%",
	  j = "vol -d 1%",
	  m = "vol -t",
	  l = "doas $HOME/bin/brness -i 1",
	  h = "doas $HOME/bin/brness -d 1",
}) do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key({ modkey, "Shift" }, k, function () awful.spawn(c) end))
end

-- ** Notifications

for k,n in pairs({
	  b = { "battery", "bat -p" },
	  t = { "time", "date +%H:%M" },
	  v = { "volume", "vol -g" },
}) do
   globalkeys = gears.table.join(
	  globalkeys,
	  awful.key({ modkey, "Shift" }, k,
		 function ()
			awful.spawn.easy_async(
			   n[2],
			   function (out) naughty.notification({ title = n[1], message = out }) end)
   end))
end

-- ** Reloading and quitting awesome

globalkeys = gears.table.join(
   globalkeys,
   awful.key({ modkey, "Shift" }, "q", awesome.restart),
   awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit))

-- * -
-- Local Variables: eval: (outline-minor-mode)
-- outline-regexp: "-- [*]+" End:
