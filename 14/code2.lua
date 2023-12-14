local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local LineN = 1
local ColumnTargetSpace = {}
for i = 1, #line do
	ColumnTargetSpace[i] = 1
end
local RockMap = {}
while line do
	local RockRow = {}
	for i = 1, #line do
		RockRow[i] = line:sub(i, i)
	end
	RockMap[LineN] = RockRow
	line = Input:read("*l")
	LineN = LineN + 1
end

local function RollNorthOrSouth(RockMap, MoveType)
	local ColumnTargetSpace = {}
	local InitialPosition = (MoveType == "North" and 1 or #RockMap)
	local SequenceOrder = (MoveType == "North" and 1 or -1)
	local LoopStart = (MoveType == "North" and 1 or #RockMap)
	local LoopEnd = #RockMap - LoopStart + 1
	for i = 1, #RockMap[1] do
		ColumnTargetSpace[i] = InitialPosition
	end
	local NewRockMap = {}
	for LineN = LoopStart, LoopEnd, SequenceOrder do
		local line = RockMap[LineN]
		local RockRow = {}
		NewRockMap[LineN] = RockRow
		for i = 1, #line do
			local char = line[i]
			if char == "O" then
				RockRow[i] = "."
				NewRockMap[ColumnTargetSpace[i]][i] = "O"
				ColumnTargetSpace[i] = ColumnTargetSpace[i] + SequenceOrder
			elseif char == "#" then
				ColumnTargetSpace[i] = LineN + SequenceOrder
				RockRow[i] = "#"
			else
				RockRow[i] = "."
			end
		end
	end
	return NewRockMap
end

local function Transpose(Matrix)
	local NewMatrix = {}
	for x = 1, #Matrix[1] do
		NewMatrix[x] = {}
	end
	for y = 1, #Matrix do
		for x = 1, #Matrix[y] do
			NewMatrix[x][y] = Matrix[y][x]
		end
	end
	return NewMatrix
end

local function RollBoard(RockMap, MoveType)
	-- Me re-using code efficiently with little re-design? wow, ok!
	-- print("Rolling the board", MoveType)
	if MoveType == "East" or MoveType == "West" then
		MoveType = (MoveType == "East" and "South" or "North")
		return Transpose(RollNorthOrSouth(Transpose(RockMap), MoveType))
	else
		return RollNorthOrSouth(RockMap, MoveType)
	end
end

local function PerformCycle(RockMap)
	RockMap = RollBoard(RockMap, "North")
	RockMap = RollBoard(RockMap, "West")
	RockMap = RollBoard(RockMap, "South")
	RockMap = RollBoard(RockMap, "East")
	return RockMap
end

local function TurnMapIntoString(RockMap)
	local reformed = ""
	for i,row in next,RockMap do
		reformed = reformed .. table.concat(row, "") .. "\n"
	end
	return reformed
end

local function DoCycles(RockMap)
	local UniqueMaps = {}
	local MapsByOrder = {}
	for i = 1, 1000000000 do --thats a lot of cycles
		local NewRockMap = PerformCycle(RockMap)
		local NewRockMapIdentifier = TurnMapIntoString(NewRockMap)
		if UniqueMaps[NewRockMapIdentifier] then
			local diff = i - UniqueMaps[NewRockMapIdentifier]
			print("Found a repeat", i, "cycles in (diff of", diff, ")")
			return MapsByOrder[(#MapsByOrder-diff) + ((1000000000-i+1)%diff)]
		else
			RockMap = NewRockMap
			UniqueMaps[NewRockMapIdentifier] = i
			MapsByOrder[i] = NewRockMap
		end
	end
end

RockMap = DoCycles(RockMap)

print("Fianl rock map:\n" .. TurnMapIntoString(RockMap))

local Total = 0
for i,row in next,RockMap do
	for j = 1, #row do
		if row[j] == "O" then
			Total = Total + (#RockMap-i+1)
		end
	end
end

print("Total load:", Total)
