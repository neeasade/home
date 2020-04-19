require("vis")

local function settitle(title)
	vis:command(string.format(":!printf '\\033]]0;vis: %s\\a'", title))
end

local function endswith(str, en)
	return string.sub(str, string.len(str)-string.len(en)+1, -1) == en
end

vis.events.subscribe(vis.events.INIT, function()
	-- hijacking set_syntax so we can have proper SELECTION style
	-- i don't use syntax highlighting nor do i care about it
	vis.types.window.set_syntax = function(win, syntax)
		win:style_define(win.STYLE_CURSOR, "back: 16")
		win:style_define(win.STYLE_STATUS, "")
		win.syntax = nil
		return true
	end

	vis:command("set tw 4")
	vis:command("set syntax off")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	if win.file.path == nil then
		settitle("*new*")
	elseif string.sub(win.file.path, 1, 9) ~= "/home/viz" then
		settitle(win.file.path)
	else
		settitle("~" .. string.sub(win.file.path, 10, -1))
	end

	if win.file.path ~= nil and endswith(win.file.path, ".nix") then
		vis:command("set tw 2")
		vis:command("set et on")
	else
		vis:command("set tw 4")
		vis:command("set et off")
	end
end)