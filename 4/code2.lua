--[==[ Post-Completion Explanation
Very similar to part 1, except this time, We store how many extra copies of the upcoming cards we have.
Once we get to each card, we make sure to factor in how many extra copies of the current card we had as well when increasing later cards
]==]
local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local Total = 0
local BonusCards = setmetatable({}, {__index=function(t,k) return 0 end})
while line do
	local CardN, Winners, Numbers = line:match("^Card +(%d+): ([^|]+) | (.+)$")
	local ExtraCopies = BonusCards[tonumber(CardN)]
	local WinningNumbers = {}
	local Matches = 0
	for number in Winners:gmatch("([^ ]+) ?") do
		WinningNumbers[number] = true
	end
	for number in Numbers:gmatch("([^ ]+) ?") do
		if WinningNumbers[number] then
			Matches = Matches + 1
		end
	end
	for i = 1, Matches do
		BonusCards[CardN+i] = BonusCards[CardN+i] + 1+ExtraCopies
	end
	Total = Total + 1 + ExtraCopies
	line = Input:read("*l")
end
print("Total:", Total)
