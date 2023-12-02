local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local Total = 0
while line do
	local GameID, Games = line:match("^Game (%d+): (.+)$")
	local HighestRed = 0
	local HighestGreen = 0
	local HighestBlue = 0
	for set in Games:gmatch("[^;]+") do
		local red = tonumber(set:match("(%d+) red"))
		local green = tonumber(set:match("(%d+) green"))
		local blue = tonumber(set:match("(%d+) blue"))
		HighestRed = math.max(HighestRed, red or 0)
		HighestGreen = math.max(HighestGreen, green or 0)
		HighestBlue = math.max(HighestBlue, blue or 0)
	end
	Total = Total + (HighestRed * HighestGreen * HighestBlue)
	line = Input:read("*l")
end
print("Total:", Total)
