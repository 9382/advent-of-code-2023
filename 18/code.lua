local Input = io.open("input.txt", "r")

local line = Input:read("*l")
local NORTH, EAST, SOUTH, WEST = 0, 1, 2, 3
local LRPoint = 0
local UDPoint = 0
local LowestX, HighestX = 0, 0
local LowestY, HighestY = 0, 0
local Sequence = {}
while line do
	local Dir, Distance, Paint = line:match("^([URDL]) (%d+) %(#([0-9a-f]+)%)$")
	Dir = ({U=NORTH, R=EAST, D=SOUTH, L=WEST})[Dir]
	Distance = tonumber(Distance)
	Sequence[#Sequence+1] = {Direction=Dir, Distance=Distance, Paint=Paint}
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
local Board = {}
for i = 1, ColumnLength do
	local Row = {}
	for j = 1, RowLength do
		Row[j] = "."
	end
	Board[i] = Row
end
Board[Y][X] = "#"
-- really cool and lazy way to mark an inside point mostly reliably
local IY, IX
if X > RowLength/2 then
	IX = X - 1
else
	IX = X + 1
end
if Y > ColumnLength/2 then
	IY = Y - 1
else
	IY = Y + 1
end
Board[IY][IX] = "I"

local function PrintBoard()
	local s = ""
	for i = 1, #Board do
		s = s .. table.concat(Board[i], "") .. "\n"
	end
	print(s)
end
-- PrintBoard()

print("Running sequence...")
for i = 1, #Sequence do
	local Instruction = Sequence[i]
	local Dir, Distance = Instruction.Direction, Instruction.Distance
	for j = 1, Distance do
		X = X - (Dir-2)*(Dir%2)
		Y = Y + (Dir-1)*((Dir+1)%2)
		Board[Y][X] = "#"
	end
	-- PrintBoard()
end
-- PrintBoard()

local function SpreadI(InitialX, InitialY)
	-- I have to use a smart system because I caused a stack overflow :)
	local Points = {{X, Y}}
	while #Points > 0 do
		local NewPoints = {}
		for _,Point in next,Points do
			local X, Y = unpack(Point)
			for _,pair in next,{{X-1,Y},{X+1,Y},{X,Y-1},{X,Y+1}} do
				local NextX, NextY = unpack(pair)
				if Board[NextY][NextX] == "." then
					Board[NextY][NextX] = "I"
					NewPoints[#NewPoints+1] = {NextX, NextY}
				end
			end
		end
		Points = NewPoints
	end
end
print("Spreading I...")
SpreadI(IX, IY)
PrintBoard()

local InsideSize = 0
for i = 1, #Board do
	local Row = Board[i]
	for j = 1, #Row do
		if Row[j] == "I" or Row[j] == "#" then
			InsideSize = InsideSize + 1
		end
	end
end
print("Inside size:", InsideSize)
