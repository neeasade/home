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
-- Most commands are bound under s-x except a few like tag-related
-- commands which use s-N, s-S-N, and C-s-N.  This way Emacs gets even
-- more free key sequences.

-- TODO: Support C-h.  Maybe gears.debug.dump_return might prove
-- useful.
globalkeys = {}
clientkeys = {}

-- Modifier weight.  Shift is ignored.
-- Order: C-M-s
key__modifier_weight = {
  ["Control"] = 10,
  ["Meta"] = 9,
  ["Mod4"] = 8,
  ["Shift"] = -1
}

-- Shorthand representation of modifier keys.
key__modifier_repr = {
  ["Control"] = "C-",
  ["Meta"] = "M-",
  ["Mod4"] = "s-",
}

-- Get the representation of MODIFIERS in an Emacs-ey style.
--
-- It ignores the Shift modifier.
function key__modifiers_repr(modifiers)
  local repr = ""

  table.sort(modifiers, function(a, b)
               return key__modifier_weight[a] > key__modifier_weight[b]
  end)

  -- If Shift is present, then remove it
  if modifiers[#modifiers] == "Shift" then
    table.remove(modifiers, #modifiers)
  end

  for _, m in ipairs(modifiers) do
    repr = repr .. key__modifier_repr[m]
  end

  return repr
end

-- Return non-nil if KEY is a modifier.
function key__key_modifier_p(key)
  for _, k in pairs({ "Control_L", "Control_R", "Super_L", "Super_R", "Alt_L", "Alt_R", "Shift_L", "Shift_R" }) do
    if key == k  then
      return true
    end
  end
  return nil
end

key__exit_keys = { "q", "C-g" }

-- See keymap__lookup_key.
function keymap__lookup_transform(command)
  if type(command) == "string" then
    return function() awful.spawn(command) end
  end

  return command
end

-- Lookup KEY in MAP.
--
-- MAP is a list of { keysequence, command }.  If “command” is a
-- string, then it is turned into a “awful.spawn” call.  Otherwise, it
-- is retained as is.
--
-- Return { keysequence, command } if found; otherwise, nil.
function keymap__lookup_key(key, map)
  for _, k in ipairs(map) do
    if k[1] == key then
      return { k[1], keymap__lookup_transform(k[2]) }
    end
  end

  return nil
end

-- Return a message to be displayed for MAP.
function repeat_map__message(map)
  return table.concat(gears.table.map(function(k) return k[1] end, map), ", ")
end

-- Return a function that will make commands in MAP repeatable.
--
-- TRIGGER is the key that should be pressed in order to trigger this
-- repeat map.
function define_repeat_map(map, trigger)
  return function (c)
    local grabber
    local notify = naughty.notify{
      text = "Repeat with " .. repeat_map__message(map),
      timeout = 0
    }
    grabber = awful.keygrabber.run(function(modifiers, key, event)
        if event == "release" then return end

        -- If KEY is a modifier, then ignore it this run.
        if key__key_modifier_p(key) then
          return
        end

        local lookup = ""

        -- If MODIFIERS exists, then convert it to an Emacs-ey
        -- representation.
        if #modifiers > 0 then
          lookup = key__modifiers_repr(modifiers)
        end

        -- Then attach the KEY.
        lookup = lookup .. key

		-- TODO: Exit on key__exit_keys (also rename).
        -- If LOOKUP is the keysequence that triggered this keymap, then
        -- ignore this run.
        -- if lookup == trigger then
        -- return
        -- end

        command = keymap__lookup_key(lookup, map)
        if command then
          command[2](c)
        else
          awful.keygrabber.stop(grabber)
          naughty.destroy(notify)
        end
    end)
  end
end

-- A keymap of global commands.
global_map = {}

function define_map(map)
  return function(c)
    local grabber
    grabber = awful.keygrabber.run(function(modifiers, key, event)
        if event == "release" then return end

        -- If KEY is a modifier, then ignore it this run.
        if key__key_modifier_p(key) then
          return
        end

        local lookup = ""

        -- If MODIFIERS exists, then convert it to an Emacs-ey
        -- representation.
        if #modifiers > 0 then
          lookup = key__modifiers_repr(modifiers)
        end

        -- Then attach the KEY.
        lookup = lookup .. key

        -- naughty.notify{title=lookup}

        -- If LOOKUP is the keysequence that triggered this keymap, then
        -- ignore this run.
        -- if lookup == trigger then
          -- return
        -- end

        command = keymap__lookup_key(lookup, map)
        -- naughty.notify{title=gears.debug.dump_return(command)}

        if command then
          command[2](c)
        else
          naughty.notify{ text = "s-x " .. lookup .. " is undefined" }
        end
        awful.keygrabber.stop(grabber)
    end)
  end
end

-- TODO: There should be a property table that lets you make a command
-- trigger a repeat-map automatically.
-- Make s-x KEY run COMMAND.
function define_key(key, command)
  global_map = gears.table.join(
    global_map,
    {{ key, command }}
  )
end

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

function notify(title, command)
  return function()
    awful.spawn.easy_async(
      command,
      function(out)
        naughty.notify{ title = title, text = out }
    end)
  end
end

for k, c in pairs({
    v = define_repeat_map({
        { "v", notify("Volume", "vol -g") },
        { "+", "vol -i 1%" },
        { "=", "vol -i 1%" },
        { "-", "vol -d 1%" },
    }, "v"),
    ["C-l"] = "slock",
    m = "mus",
    ["s-o"] = "org-capture",
    ["s-n"] = "emacsclient -c --eval '(find-file \"~/doc/uni/notes/annotations.org\")'",
    r = "menu run",
    V = "chromium",
    e = editor,
    p = terminal,
    ["C-c"] = "turnoff",
    M = "vol -t",
    B = define_repeat_map({
        { "+", "doas /home/viz/bin/brness -i 1"},
        { "=", "doas /home/viz/bin/brness -i 1"},
        { "-", "doas /home/viz/bin/brness -d 1"},
        { "b", notify("Brightness", "brness") },
    }, "B"),
    b = notify("Battery", "bat -p"),
    t = notify("Time", "date +%H:%M"),
}) do
  define_key(k, c)
end

globalkeys = gears.table.join(
  globalkeys,
  awful.key({}, "Print",
    function() awful.spawn("screenshot") end,
    { description = "Take screenshot and copy to clipboard", group = "global" }))

-- ** Awesome
-- globalkeys = gears.table.join(
--   globalkeys,
--   awful.key({ modkey, "Shift" }, "q", awesome.restart),
--   awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit))

-- ** Client keybinds
client_map = {}

function define_client_key(key, command)
  client_map = gears.table.join(
    client_map,
    {{ key, command }}
  )
end

-- *** Resize and move
do
  local move_map = {}
  move_repeat_map = nil
  for d,c in pairs({
      ["Up"] = { 0, -50 }, ["Down"] = { 0,  50 },
      ["Left"] = { -50, 0 }, ["Right"] = { 50,  0 },
  }) do
    move_map[#move_map+1] = { d,
      function()
        if client.focus then
          client.focus:relative_move(c[1], c[2], 0, 0)
        end
    end
    }

    move_map[#move_map+1] = { "s-" .. d,
      function()
        if client.focus then
          client.focus:relative_move(0, 0, c[1], c[2])
        end
    end
    }

    define_key(d, function()
                 if client.focus then
                   client.focus:relative_move(c[1], c[2], 0, 0)
                   move_repeat_map()
                 end
    end)

    define_key("s-" .. d, function()
                 if client.focus then
                   client.focus:relative_move(0, 0, c[1], c[2])
                   move_repeat_map()
                   end
    end)
  end
  move_repeat_map = define_repeat_map(move_map, "")
end

-- *** Focus
-- Turn on autofocus
require("awful.autofocus")

define_key("Return", function()
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
end)

other_window_repeat_map = define_repeat_map(
  {
    { "o", function() awful.client.focus.byidx(1) end },
    { "O", function() awful.client.focus.byidx(-1) end },
  },
  "")

define_key("o", function()
             awful.client.focus.byidx(1)
             other_window_repeat_map()
end)

define_key("O", function()
             awful.client.focus.byidx(-1)
             other_window_repeat_map()
end)

-- Flash borders to better find the focused window
vz_flash_focus_even = true
vz_flash_focus_client = nil

vz_flash_focus_timer = gears.timer{
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

define_key("s-l",
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
    end)

-- *** Snap
-- TODO: Position windows like in Windows 10
define_key(
  "f",
  function()
    client.focus.fullscreen = not client.focus.fullscreen
    -- c.maximized = not c.maximized
    -- if c.maximized then
    --   awful.titlebar.hide(c)
    --   c.border_width = 0
    -- else
    --   awful.titlebar.show(c)
    --   c.border_width = beautiful.border_width
    -- end
    client.focus:raise()
end)

define_key(
  "c",
  function()
    awful.placement.centered(client.focus)
  end)

-- *** Misc
define_key(
  "s-k",
  function()
      client.focus:kill()
end)

-- ** Register
globalkeys = gears.table.join(globalkeys, awful.key({modkey}, "x", define_map(global_map)))
clientkeys = gears.table.join(clientkeys, awful.key({modkey}, "x", define_map(client_map)))

root.keys(globalkeys)

-- * Mousebinds
-- ** Root binds
-- This requires patched slw(1) from wmutils to work properly.  Since
-- awesomewm is reparenting, slw's logic was too simple.
root.buttons(gears.table.join(awful.button({}, 3, nil, function (_) awful.spawn("reshapewin") end)))

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
     rule = { name = "vz/compose-input-method-frame" },
     properties = {
       floating = true,
       titlebars_enabled = false,
       border_width = 4,
       sticky = true,
       ontop = true,
       placement = awful.placement.under_mouse,
     },
   },
  {
    rule = { class = "Gcr-prompter" },
    properties = {
      placement = awful.placement.centered,
      ontop = true,
    },
  },
  {
    rule = { class = "Xdragon" },
    properties = {
      placement = awful.placement.top_right,
      ontop = true,
      sticky = true,
      },
  },
}

-- * -*- -*-
-- Local Variables:
-- lua-indent-level: 2
-- indent-tabs-mode: nil
-- outline-regexp: "-- [*]+ "
-- End:
