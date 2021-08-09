-- * Import Libraries
-- Import all the libraries needed by awesome

local awful = require("awful")         -- Stdlib
local gears = require("gears")         -- Stdlib
local naughty = require("naughty")     -- Notifications
local wibox = require("wibox")         -- Widgets
local beautiful = require("beautiful") -- Theme

-- * Notify on config errors
-- On startup

if awesome.startup_errors then
  naughty.notify({
      preset = naughty.config.presets.critical,
      title = "An error on startup",
      text = awesome.startup_errors,
  })
end

-- On reloading and similar
do
  local inerr = false
  awesome.connect_signal(
    "debug::error",
    function(err)
      if inerr then return end
      inerr = true
      naughty.notify({
          preset = naughty.config.presets.critical,
          title = "An error in awesome config",
          text = tostring(err),
      })
      inerr = false
  end)
end

-- * Initialise variables and theme
-- Theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Modkey used for keybinds
modkey = "Mod4" 				-- Super

-- Terminal and editor
terminal = "eterm || st"
editor = "emacsclient -c"

-- * Layouts
-- I only care for floating and here we are
awful.layout.layouts = {
  awful.layout.suit.floating,
}

-- Manage clients
client.connect_signal(
  "manage",
  function(c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
    end
end)

-- * Wallpaper
-- I have a file at $XDG_CACHE_HOME/wall which stores the bgs command
-- to be run so parse that. However, there's nothing like -z flag in
-- gears' wallpaper functions.
local cairo = require("lgi").cairo

-- Also see: https://stackoverflow.com/questions/6565703/math-algorithm-fit-image-to-screen-retain-aspect-ratio
function vz_wallpaper_zoom(surf, s, background)
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

-- * Set tags
-- One of the two reasons why I chose awesome

awful.screen.connect_for_each_screen(function(s)
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}, s, awful.layout.layouts[1])
end)

-- * Keybinds
-- Set these to an empty set just cuz
globalkeys = {}
clientkeys = {}

-- ** Tags
for i=1,10 do
  globalkeys = gears.table.join(
    globalkeys,
    awful.key(
      { modkey },
      "#"..i+9,
      function()
        local tag = awful.screen.focused().tags[i]
        if tag then tag:view_only() end
      end,
      { description = "Switch to tag #"..i, group = "tag" }),
    awful.key(
      { modkey, "Control" },
      "#"..i+9,
      function()
        local tag = awful.screen.focused().tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
          -- TODO: Also raise all the clients in the tag
        end
      end,
      { description = "Toggle tag #"..i, group = "tag" }),
    awful.key(
      { modkey, "Shift" },
      "#"..i+9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:move_to_tag(tag) end
        end
      end,
      { description = "Move focused window to tag #"..i, group = "tag" }))
end

-- ** Spawn windows and commands
for k,c in pairs({
    e = editor,
    v = "chromium",
    Print = "screenshot -u",
    l = "slock",
    m = "mus",
    r = "menu run",
    o = "org-capture",
    n = "emacsclient -c --eval '(find-file \"~/doc/uni/notes/annotations.org\")'"
}) do
  globalkeys = gears.table.join(
    globalkeys,
    awful.key(
      { modkey }, k,
      function() awful.spawn(c) end,
      { description = c, group = "global" }))
end

-- With shift modifier
for k,c in pairs({
    Return = terminal,
    x = "turnoff",
    k = "vol -i 1%",
    j = "vol -d 1%",
    m = "vol -t",
    l = "doas /home/viz/bin/brness -i 1",
    h = "doas /home/viz/bin/brness -d 1",
    p = "elisp -t '(vz/org-clock-in)'",
}) do
  globalkeys = gears.table.join(
    globalkeys,
    awful.key(
      { modkey, "Shift" }, k,
      function() awful.spawn(c) end,
      { description = c, group = "global" }))
end

-- With shift and control modifier
for k,c in pairs({
    r = "pkill -USR1 redshift",
}) do
  globalkeys = gears.table.join(
    globalkeys,
    awful.key(
      { modkey, "Control", "Shift" }, k,
      function() awful.spawn(c) end,
      { description = c, group = "global" }))
end

-- With control modifier
for k,c in pairs({
    p = "elisp -t '(vz/org-clock-freeze)'",
}) do
  globalkeys = gears.table.join(
    globalkeys,
    awful.key(
      { modkey, "Control" }, k,
      function() awful.spawn(c) end,
      { description = c, group = "global" }))
end

globalkeys = gears.table.join(
  globalkeys,
  awful.key({}, "Print",
    function() awful.spawn("screenshot") end,
    { description = "Take screenshot and copy to clipboard", group = "global" }))

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
          function(out) naughty.notify { title = n[1], text = out } end)
      end,
      { description = "Notify " .. n[1], group = "Notifications" }))
end

-- ** Awesome
globalkeys = gears.table.join(
  globalkeys,
  awful.key({ modkey, "Shift" }, "q", awesome.restart),
  awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit))

-- ** Client keybinds
clientkeys = {}

-- *** Resize and move
for d,c in pairs({
    w = { 0, -50 }, s = { 0,  50 },
    a = { -50, 0 }, d = { 50,  0 },
}) do
  clientkeys = gears.table.join(
    clientkeys,
    awful.key(
      { modkey }, d,
      function()
        if client.focus then
          client.focus:relative_move(c[1], c[2], 0, 0)
        end
      end,
      { description = "Move", group = "client" }),
    awful.key(
      { modkey, "Shift" }, d,
      function()
        if client.focus then
          client.focus:relative_move(0, 0, c[1], c[2])
        end
      end,
      { description = "Resize", group = "client" }))
end

-- *** Focus
-- Turn on autofocus
require("awful.autofocus")

for k,d in pairs({ h = "left", j = "down",
                   k = "up", l = "right" }) do
  clientkeys = gears.table.join(
    clientkeys,
    awful.key({ modkey, "Control" }, k,
      function()
        awful.client.focus.bydirection(d)
        client.focus:raise()
      end,
      { description = "Focus towards " .. d, group = "client" }))
end

-- Flash borders to better find the focused window
vz_flash_focus_even = true
vz_flash_focus_client = nil

vz_flash_focus_timer = gears.timer {
  timeout = 0.25,
  call_now = false,
  autostart = false,
  callback = function()
    if vz_flash_focus_client then
      vz_flash_focus_client.border_width = 10
      if vz_flash_focus_even then
        vz_flash_focus_client.border_color =  "#000fff"
      else
        vz_flash_focus_client.border_color = "#fff000"
      end
      vz_flash_focus_even = not vz_flash_focus_even
    end
end}

clientkeys = gears.table.join(
    clientkeys,
    awful.key({ modkey, "Shift" }, "f",
      function()
        if vz_flash_focus_timer.started then
          vz_flash_focus_timer:stop()
          vz_flash_focus_client.border_color = beautiful.border_focus
          vz_flash_focus_client.border_width = beautiful.border_width
          vz_flash_focus_client = nil
        else
          vz_flash_focus_client = client.focus
          vz_flash_focus_timer:again()
        end
      end,
      { description = "Flash border of focused window", group = "client" }))

-- Select the window by name
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey }, "p",
      function()
        local clients, menustring = awful.screen.focused():get_clients(), {}
        if #clients == 0 then return end
        for i,c in pairs(awful.screen.focused():get_clients()) do
          menustring[#menustring+1] = tostring(i) .. " | " .. (c.name or "<unknown>")
        end
        awful.spawn.easy_async_with_shell(
          "echo \"" .. table.concat(menustring, "\n") .. "\" | menu sel",
          function(out)
            if #out == 0 then return end
            local idx = -1
            for i in string.gmatch(out, "%S+") do
              idx = tonumber(i)
              break
            end
            -- I have to move the course otherwise sloppy focus kicks in
            mouse.coords{
              x = clients[idx].x+(clients[idx].width/2),
              y = clients[idx].y+(clients[idx].height/2),
            }
            clients[idx]:raise()
            client.focus = clients[idx]
        end)
      end,
      { description = "Select window by name in a menu", group = "client" }))

-- *** Snap
-- TODO: Position windows like in Windows 10
clientkeys = gears.table.join(
  clientkeys,
  awful.key({ modkey }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      -- c.maximized = not c.maximized
      -- if c.maximized then
      --   awful.titlebar.hide(c)
      --   c.border_width = 0
      -- else
      --   awful.titlebar.show(c)
      --   c.border_width = beautiful.border_width
      -- end
      c:raise()
    end,
    { description = "Fullscreen", group = "client"}),
  awful.key({ modkey }, "c",
    function(c)
      awful.placement.centered(c)
    end,
    { description = "Centre", group = "client" }))

-- *** Misc
clientkeys = gears.table.join(
  clientkeys,
  awful.key({ modkey, "Shift" }, "c",
    function(c)
      c:kill()
    end,
    { description = "Suicide", group = "client" }))

-- ** Register
root.keys(globalkeys)

-- * Mousebinds
-- ** Client binds
-- *** Sloppy focus
client.connect_signal(
  "mouse::enter",
  function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- *** Move and resize
clientbuttons = gears.table.join(
  awful.button({}, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.resize(c)
end))

-- * Window decorations
-- ** Titlebars
client.connect_signal(
  "request::titlebars",
  function(c)
    local buttons = gears.table.join(
      awful.button({}, 1, function()
          c:emit_signal("request::activate", "titlebar", { raise = true })
          awful.mouse.client.move(c)
      end),
      awful.button({}, 3, function()
          c:emit_signal("request::activate", "titlebar", { raise = true })
          awful.mouse.client.resize(c)
      end),
      awful.button({}, 2, function() c:kill() end))
    awful.titlebar(c):setup{
      {
        layout = wibox.layout.fixed.horizontal,
        buttons = buttons,
      },
     {
        { align = "center", widget = awful.titlebar.widget.titlewidget(c) },
        layout = wibox.layout.flex.horizontal,
        buttons = buttons,
      },
      {
        awful.titlebar.widget.closebutton(c),
        layout = wibox.layout.fixed.horizontal(),
      },
      layout = wibox.layout.align.horizontal,
                           }
end)

-- ** Borders
-- On focus change
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- * Rules

function vz_place_under_cursor_or_centre(c, args)
  local len = 0

  for i in pairs(awful.screen.focused():get_clients()) do
    len = len + 1
    if len == 2 then break end
  end

  if len == 2 then
    return (awful.placement.under_mouse+awful.placement.no_offscreen)(c)
  else
    return awful.placement.centered(c, args)
  end
end

awful.rules.rules = {
  {  -- Register client key and mouse binds and set initial decoration
    rule = {},
    properties = {
      keys = clientkeys,
      buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      placement = vz_place_under_cursor_or_centre,
    },
  },
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true },
  },
  {
    rule = { class = "Chromium-browser" },
    properties = {
      tag = "2",
      maximized = false, -- Chrome starts maximized which disables mousebinds
      maximized_horizontal = false,
      maximized_vertical = false,
    },
  },
  {
    rule = { class = "Firefox" },
    properties = {
      maximized = false,
    },
  },
  {
    rule = { class = "mpv", instance = "mpv-popup" },
    properties = {
      floating = true,
      titlebars_enabled = false,
      is_fixed = true,
      sticky = true,
      ontop = true,
      border_width = 0,
    },
  },
  {
    rule = { name = "vz/org-capture-frame" },
    properties = {
      floating = true,
      placement = awful.placement.top+awful.placement.maximize_horizontally,
      titlebars_enabled = false,
      sticky = true,
      border_width = 2,
    },
  },
  {
    rule = { name = "vz/emacs-minibuffer-only-frame" },
    properties = {
      floating = true,
      titlebars_enabled = false,
      border_width = 4,
      sticky = true,
      ontop = true,
      placement = awful.placement.centered,
      },
   },
  {
    rule = { class = "Gcr-prompter" },
    properties = {
      placement = awful.placement.centered,
      ontop = true,
    },
  },
}

-- * -*- -*-
-- Local Variables:
-- eval: (outline-minor-mode)
-- lua-indent-level: 2
-- indent-tabs-mode: nil
-- outline-regexp: "-- [*]+ "
-- End:
