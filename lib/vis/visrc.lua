require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- hijacking set_syntax so we can have proper SELECTION style
	-- i don't use syntax highlighting nor do i care about it
	vis.types.window.set_syntax = function(win, syntax)
		win:style_define(win.STYLE_CURSOR, 'back: 16')
		win.syntax = nil
		return true
	end

	vis:command('set tw 4')
	vis:command('set syntax off')
end)

-- vis.events.subscribe(vis.events.WIN_OPEN, function(win)
-- end)