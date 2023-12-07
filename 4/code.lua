local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local Total = 0
while line do
	local CardN, Winners, Numbers = line:match("^Card +(%d+): ([^|]+) | (.+)$")
	local WinningNumbers = {}
	local Value = 0
	for number in Winners:gmatch("([^ ]+) ?") do
		WinningNumbers[number] = true
	end
	for number in Numbers:gmatch("([^ ]+) ?") do
		if WinningNumbers[number] then
			if Value == 0 then
				Value = 1
			else
				Value = Value * 2
			end
		end
	end
	Total = Total + Value
	line = Input:read("*l")
end
print("Total:", Total)
