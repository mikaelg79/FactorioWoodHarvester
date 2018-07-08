-- util.lua

function debug_print(...)
    if debug_on ~= 1 then return end

	local str = ""
	
	for i, istr in ipairs({...}) do
		str = str .. tostring(istr)
	end

	for _, player in pairs(game.players) do
		if player.connected then player.print(str) end
	end
end
