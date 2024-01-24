ui.Panel.bind("backspace", function(pnl)

	local c = tty.get_canvas()
	local x
    local y
    x, y = c:get_xy()

    if x == 0 or c:get_char_at(x-2, y) == '$' then
        pnl.dir = '..'
    else
        return false
    end

end)
