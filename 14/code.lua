--[==[ Post-Completion Explanation
We figure out how far something should roll by tracking the last blocking element in each column
Then, if we encounter a rock, we move it to the first known available position, and adjust the available position as needed
Once we've done this, we just add up the total, and that's it
]==]
local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local LineN = 1
local ColumnTargetSpace = {}
for i = 1, #line do
	ColumnTargetSpace[i] = 1
end
local NewRockMap = {}
while line do
	local RockRow = {}
	NewRockMap[LineN] = RockRow
	for i = 1, #line do
		local char = line:sub(i, i)
		if char == "O" then
			RockRow[i] = "."
			NewRockMap[ColumnTargetSpace[i]][i] = "O"
			ColumnTargetSpace[i] = ColumnTargetSpace[i] + 1
		elseif char == "#" then
			ColumnTargetSpace[i] = LineN + 1
			RockRow[i] = "#"
		else
			RockRow[i] = "."
		end
	end
	line = Input:read("*l")
	LineN = LineN + 1
end
print("Rolled all the rocks north")

local Total = 0
for i,row in next,NewRockMap do
	for j = 1, #row do
		if row[j] == "O" then
			Total = Total + (#NewRockMap-i+1)
		end
	end
end

print("Total load:", Total)
