local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local MaxRed = 12
local MaxGreen = 13
local MaxBlue = 14
local Total = 0
while line do
	local GameID, Games = line:match("^Game (%d+): (.+)$")
	local Valid = true
	for set in Games:gmatch("[^;]+") do
		local red = tonumber(set:match("(%d+) red"))
		local green = tonumber(set:match("(%d+) green"))
		local blue = tonumber(set:match("(%d+) blue"))
		if red and red > MaxRed then
			Valid = false
			break
		end
		if green and green > MaxGreen then
			Valid = false
			break
		end
		if blue and blue > MaxBlue then
			Valid = false
			break
		end
	end
	if Valid then
		Total = Total + tonumber(GameID)
	end
	line = Input:read("*l")
end
print("Total:", Total)
