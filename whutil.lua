-- whutil.lua

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

function splitversion(str)
	local version = {}
	for x,y,z in string.gmatch(str, "(%d+)%.(%d+)%.(%d+)") do
		version["major"] = tonumber(x)
		version["minor"] = tonumber(y)
		version["build"] = tonumber(z)
	end
	return version
end
