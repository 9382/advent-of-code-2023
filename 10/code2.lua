--[==[ Post-Completion Explanation
This script is a right-old mess, and should not be as long as it is.
It would have probably helped a good deal if I had defined N, E, S, W as 0 to 3 instead of 1 to 4, as it would've allowed rotating via maths instead of table indexing.
(I do this in later puzzles as its far easier to work with)

We first of all start the same way as part 1 (L70 -> L111), as we want to find out where our pipe loop is (and subsequently where all the dummy pipes are too)
Note that we figure out what pipe type S is meant to be - this is important for the next step to work, since we probably won't be starting at S again next time
From this point on, any pipe that isn't part of the main loop is basically treated like a "."

Next, we pick a random piece (in our case, the top-leftmost piece we can find), and we do a second traversal (L113 -> L167)
This time, we want to track an inside border to our pipe. Since we always picked the top-leftmost piece (an F), we can
always know which way is guaranteed to be the direction of the "inside", and we rotate this as required as we move around.

Once we've finished the second traversal, we mark all inside spots that weren't the pipe loop itself with an I and then "spread" these Is (L169 -> L191)
("Spreading" the inside like this, while perfectly valid, isn't the fastest choice, but it'll do fine for us in this case as there isn't much)
]==]
local Input = io.open("input.txt", "r")

--[[ Diescting part 2
Our goal here appears to be to define a boundary of what our loop contains
Any tile not part of the loop can be grounds for a nest, so we make everything "." after we are done

Assuming the logic in my head is correct, we can basically "patrol" the outer border of our curve
It's basically the exact same tracing logic, yet now we track everything that would be considered "Outside-adjacent"
Once we have our initial O mapping, we go through every dot and apply a simple check to see if it can find an associated O
If it can't, we have an enclosed zone and should mark it as such
(I'm going to try an initial I mapping, just cause)

This should be a safe method considering we have 1 primary non-intersecting path. This means we have a clear "inside" and "outside"

This code logically is very sound but its actually visually disgusting
it used to look *worse* but I cleaned it up a bit after solving
--]]
local TileMapping = {}
local LoopPathTiles = {} --for later
local ToBecomeInside = {} --for later
local LineNumber = 1
local RowLength
local StartX, StartY
local line = Input:read("*l")
while line do
	RowLength = #line
	local RowData = {}
	for i = 1, #line do
		local char = line:sub(i, i)
		RowData[i] = char
		if char == "S" then
			StartX, StartY = i, LineNumber
		end
	end
	TileMapping[LineNumber] = RowData
	LoopPathTiles[LineNumber] = {}
	ToBecomeInside[LineNumber] = {}
	LineNumber = LineNumber + 1
	line = Input:read("*l")
end

local NORTH, EAST, SOUTH, WEST = 1, 2, 3, 4
local ClockwiseRotation = {[NORTH]=EAST, [EAST]=SOUTH, [SOUTH]=WEST, [WEST]=NORTH}
local ReverseDirection = {[NORTH]=SOUTH, [SOUTH]=NORTH, [EAST]=WEST, [WEST]=EAST}
local PipeDirectionMapping = { --A map of "if we come in from direction X, which way do we go out?"
	["|"]={[NORTH]=NORTH, [SOUTH]=SOUTH},
	["-"]={[EAST]=EAST, [WEST]=WEST},
	["L"]={[SOUTH]=EAST, [WEST]=NORTH},
	["J"]={[SOUTH]=WEST, [EAST]=NORTH},
	["7"]={[NORTH]=WEST, [EAST]=SOUTH},
	["F"]={[NORTH]=EAST, [WEST]=SOUTH},
	["."]={},
}

local CurChar, CurX, CurY, PrevMoveDir
-- We suddenly care what S is because of a later step
if StartY > 1 and PipeDirectionMapping[TileMapping[StartY-1][StartX]][NORTH] then
	if PipeDirectionMapping[TileMapping[StartY][StartX-1]][WEST] then
		TileMapping[StartY][StartX] = "J"
	elseif StartY < #TileMapping and PipeDirectionMapping[TileMapping[StartY+1][StartX]][SOUTH] then
		TileMapping[StartY][StartX] = "|"
	else
		TileMapping[StartY][StartX] = "L"
	end
	CurX, CurY, PrevMoveDir = StartX, StartY-1, NORTH
elseif StartY < #TileMapping and PipeDirectionMapping[TileMapping[StartY+1][StartX]][SOUTH] then
	if PipeDirectionMapping[TileMapping[StartY][StartX-1]][WEST] then
		TileMapping[StartY][StartX] = "7"
	else
		TileMapping[StartY][StartX] = "F"
	end
	CurX, CurY, PrevMoveDir = StartX, StartY+1, SOUTH
else -- S connects to at least 2 nodes, assume east connecting cause why not
	TileMapping[StartY][StartX] = "-"
	CurX, CurY, PrevMoveDir = StartX+1, StartY, EAST
end
CurChar = TileMapping[CurY][CurX]
LoopPathTiles[CurY][CurX] = true

while not(CurX == StartX and CurY == StartY) do
	-- print("Char:", CurChar, "Pos:", CurX, CurY, "PrevMoveDir:", PrevMoveDir)
	local ExitDir = PipeDirectionMapping[CurChar][PrevMoveDir]
	PrevMoveDir = ExitDir
	if ExitDir == NORTH then
		CurY = CurY - 1
	elseif ExitDir == EAST then
		CurX = CurX + 1
	elseif ExitDir == SOUTH then
		CurY = CurY + 1
	elseif ExitDir == WEST then
		CurX = CurX - 1
	end
	CurChar = TileMapping[CurY][CurX]
	LoopPathTiles[CurY][CurX] = true
end
print("Calculated the initial general loop")

local LeftmostPiece, LeftmostPieceX, LeftmostPieceY = nil, 9e9, nil
for y = 1, #TileMapping do --This loop appears 2 more times later on :)
	local Row = TileMapping[y]
	for x = 1, #Row do
		if LoopPathTiles[y][x] then
			if x < LeftmostPieceX then
				LeftmostPiece, LeftmostPieceX, LeftmostPieceY = Row[x], x, y
			end
		end
	end
end

CurX, CurY = LeftmostPieceX, LeftmostPieceY
CurChar = "F" --There is no other character that the first leftmost character can be
PrevMoveDir = NORTH
local InwardsFacingDirection = EAST
local HasStarted = false --laaaaaaaaaaaaaaaazy
while not(CurX == LeftmostPieceX and CurY == LeftmostPieceY and HasStarted) do
	-- print("Char:", CurChar, "Pos:", CurX, CurY, "PrevMoveDir:", PrevMoveDir)
	HasStarted = true
	local ExitDir = PipeDirectionMapping[CurChar][PrevMoveDir]
	local DegreeOfRotation = (ExitDir-PrevMoveDir)%4
	if DegreeOfRotation == 1 then
		InwardsFacingDirection = ClockwiseRotation[InwardsFacingDirection]
	elseif DegreeOfRotation == 3 then
		InwardsFacingDirection = ReverseDirection[ClockwiseRotation[InwardsFacingDirection]] --lua logic
	end
	PrevMoveDir = ExitDir
	local NextX, NextY = CurX, CurY
	if ExitDir == NORTH then
		NextY = CurY - 1
	elseif ExitDir == EAST then
		NextX = CurX + 1
	elseif ExitDir == SOUTH then
		NextY = CurY + 1
	elseif ExitDir == WEST then
		NextX = CurX - 1
	end
	-- We are forced to apply it for both the former and latter position because BENDS!
	if InwardsFacingDirection == NORTH and CurY > #ToBecomeInside then
		ToBecomeInside[CurY-1][CurX] = true
		ToBecomeInside[NextY-1][NextX] = true
	elseif InwardsFacingDirection == EAST and CurX < RowLength then
		ToBecomeInside[CurY][CurX+1] = true
		ToBecomeInside[NextY][NextX+1] = true
	elseif InwardsFacingDirection == SOUTH and CurY < #ToBecomeInside then
		ToBecomeInside[CurY+1][CurX] = true
		ToBecomeInside[NextY+1][NextX] = true
	elseif InwardsFacingDirection == WEST and CurX > 1 then
		ToBecomeInside[CurY][CurX-1] = true
		ToBecomeInside[NextY][NextX-1] = true
	end
	CurX, CurY = NextX, NextY
	CurChar = TileMapping[CurY][CurX]
end

local function SpreadI(x, y)
	--Technically we don't need to spread diagonally since our initial mapping captures this, but its easier to code this way
	for i = -1, 1 do
		for j = -1, 1 do
			if y+j >= 1 and x+i >= 1 and y+j <= #TileMapping and x+i <= RowLength then
				if not LoopPathTiles[y+j][x+i] and TileMapping[y+j][x+i] ~= "I" then
					TileMapping[y+j][x+i] = "I"
					SpreadI(x+i, y+j)
				end
			end
		end
	end
end
for y = 1, #TileMapping do
	local Row = TileMapping[y]
	for x = 1, #Row do
		if not LoopPathTiles[y][x] then
			if ToBecomeInside[y][x] then
				SpreadI(x, y)
			end
		end
	end
end

local CountOfI = 0
local StringVersion = ""
for y = 1, #TileMapping do
	local Row = TileMapping[y]
	for x = 1, #Row do
		if not LoopPathTiles[y][x] then
			if ToBecomeInside[y][x] or Row[x] == "I" then
				CountOfI = CountOfI + 1
				Row[x] = "I"
				StringVersion = StringVersion .. "I"
			else
				Row[x] = "."
				StringVersion = StringVersion .. "."
			end
		else
			StringVersion = StringVersion .. Row[x]
		end
	end
	StringVersion = StringVersion .. "\n"
end
print("Amount of 'I's:", CountOfI)
-- print(StringVersion)
