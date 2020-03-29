require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- hijacking set_syntax so we can have proper SELECTION style
	-- i don't use syntax highlighting nor do i care about it
	vis.types.window.set_syntax = function(win, syntax)
		win:style_define(win.STYLE_STATUS, '')
		win:style_define(win.STYLE_STATUS_FOCUSED, '')
		return true
	end

	vis:command('set tw 4')
	vis:command('set syntax off')
end)

-- vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- this needs to be executed per window
-- 	vis:command('set show-eof off')
-- end)
