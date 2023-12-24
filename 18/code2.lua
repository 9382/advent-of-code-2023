-- [!] INVALID SOLUTION: THIS SCRIPT WILL NOT ALWAYS RUN TO COMPLETION AND MAY GENERATE THE WRONG RESULT IN SOME (UNKOWN) CASES [!]
--[==[ Post-Forfeit Explanation
The main idea this script revolves around is tracking just where every wall is instead of the entire grid
We then traverse downwards through each column, noting when we swap from inside to outside and vice versa, and figure out our area that way.
We could improve ram consumption by storing the range each wall contains, but due to complications with checking 10 million columns,
making that specific part of the process any slower would probably be a mistake.

Unfortunately, due to reasons that I can't feasably debug (but I have a singular, probably wrong guess for), only on the large dataset with paint
does it apparently generate the *wrong* solution, being too low apparently. This doesn't happen for any of the other 3 cases I have available to me
For those reasons, and a lack of motivation, this script is as close as I'll be getting to a day 18 solution
]==]
local Input = io.open("input.txt", "r")

--[[ Part 2 comments
We have to take this very carefully
There's no universe where we can form an actual grid, its wayyyyy too expensive
My idea is to track in each column where substantial changes happen
Then we just go down each column, and track whether we are inside or outside (if there was or wasnt a dig onwards)
That's poorly explained but it should work
--]]
local line = Input:read("*l")
local NORTH, EAST, SOUTH, WEST = 0, 1, 2, 3
local LRPoint = 0
local UDPoint = 0
local LowestX, HighestX = 0, 0
local LowestY, HighestY = 0, 0
local Sequence = {}
while line do
	local Dir, Distance, Paint = line:match("^([URDL]) (%d+) %(#([0-9a-f]+)%)$")
	Distance, Dir = tonumber(Paint:sub(1, 5), 16), tonumber(Paint:sub(6, 6))
	-- Dir = ({U=NORTH, R=EAST, D=SOUTH, L=WEST})[Dir]
	-- Distance = tonumber(Distance)
	Sequence[#Sequence+1] = {Direction=Dir, Distance=Distance}
	LRPoint = LRPoint - (Dir-2)*(Dir%2)*Distance
	UDPoint = UDPoint + (Dir-1)*((Dir+1)%2)*Distance
	LowestX = math.min(LRPoint, LowestX)
	HighestX = math.max(LRPoint, HighestX)
	LowestY = math.min(UDPoint, LowestY) -- LowestY is actually the most NORTH we get, because yes
	HighestY = math.max(UDPoint, HighestY)
	line = Input:read("*l")
end

local X, Y = -LowestX+1, -LowestY+1 --1-indexed moment
local RowLength = HighestX-LowestX+1
local ColumnLength = HighestY-LowestY+1
print("Size:", RowLength .. "X by " .. ColumnLength .. "Y")

print("Creating column rows...")
local ColumnChanges = {}
for i = 1, RowLength do
	ColumnChanges[i] = {Values={}}
end
print("Running sequences...")
for i = 1, #Sequence do
	local Instruction = Sequence[i]
	local Dir, Distance = Instruction.Direction, Instruction.Distance
	if (Dir%2) == 0 then --North/South
		local Changes = ColumnChanges[X]
		for j = 1, Distance do
			Y = Y + (Dir-1)
			Changes.Values[#Changes.Values+1] = Y
			Changes[Y] = true
		end
	else --East/West
		for j = 1, Distance do
			X = X - (Dir-2)
			local Changes = ColumnChanges[X]
			Changes.Values[#Changes.Values+1] = Y
			Changes[Y] = true
		end
	end
end

print("Calculating internal area...")
local InsideSize = 0
for i = 1, RowLength do
	local ColumnData = ColumnChanges[i]
	table.sort(ColumnData.Values)
	local CurrentlyInside = false
	local PrevValue = 0
	local j = 1
	while j <= #ColumnData.Values do -- not a standard for j = loop since I need variable modification
		-- this is an absolute mess of a mix of values and not values but its whatever since it works
		local Values = ColumnData.Values
		if ColumnData[Values[j]+1] then --Vertical movement (complex)
			local k = Values[j]+1
			while ColumnData[k+1] do
				k = k + 1
			end
			k = k - Values[j] + j
			local TargetX = (i == 1 and i + 1 or i - 1)
			if ColumnChanges[TargetX][Values[j]] == ColumnChanges[TargetX][Values[k]] then -- we enter the way we exit, inside status is unchanged
				if not CurrentlyInside then
					InsideSize = InsideSize + (k - j + 1)
				end
			else -- we have gone from inside to outside or vice versa
				if CurrentlyInside then --exit at k
					InsideSize = InsideSize + (Values[k] - PrevValue + 1)
					PrevValue = Values[k] --doesnt really matter
				else --enter at j
					PrevValue = Values[j]
				end
				CurrentlyInside = not CurrentlyInside
			end
			j = k
		else --Horizontal movement (simple)
			if CurrentlyInside then
				InsideSize = InsideSize + (Values[j] - PrevValue + 1)
			end
			CurrentlyInside = not CurrentlyInside
			PrevValue = Values[j]
		end
		j = j + 1
	end
end

print("Inside size:", InsideSize)
