--[==[ Post-Completion Explanation
Since our goal here is to find the farthest point from the start, and given that this pipe system is linear and looping,
we can just find how many steps it takes to do a loop and divide that by 2.
We therefore start at S, pick a random (valid) direction, and traverse from there until we arrive back at S

We figure out our path by having a table of "If we came into this pipe going X, which way do we leave?" (PipeDirectionMapping)
]==]
local Input = io.open("input.txt", "r")

-- The paths that the animal can take are quite literally very linear, since there's never a multiple choice.
-- For this reason we can somewhat cheat our counting method - just do a loop counting, then grab the middle number
-- Interestingly, if I'm thinking of this correctly, there will always be an even number of steps
local TileMapping = {}
local LineNumber = 1
local StartX, StartY
local line = Input:read("*l")
while line do
	local RowData = {}
	for i = 1, #line do
		local char = line:sub(i, i)
		RowData[i] = char
		if char == "S" then
			StartX, StartY = i, LineNumber
		end
	end
	TileMapping[LineNumber] = RowData
	LineNumber = LineNumber + 1
	line = Input:read("*l")
end

local NORTH, EAST, SOUTH, WEST = 1, 2, 3, 4
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
-- We don't actually care what S is, we just care which way we go out
if PipeDirectionMapping[TileMapping[StartY-1][StartX]][NORTH] then
	CurX, CurY, PrevMoveDir = StartX, StartY-1, NORTH
elseif PipeDirectionMapping[TileMapping[StartY+1][StartX]][SOUTH] then
	CurX, CurY, PrevMoveDir = StartX, StartY+1, SOUTH
else -- S connects to at least 2 nodes, assume east connecting cause why not
	CurX, CurY, PrevMoveDir = StartX+1, StartY, EAST
end
CurChar = TileMapping[CurY][CurX]

local Steps = 1
while CurChar ~= "S" do
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
	Steps = Steps + 1
end

print("Furthest step away:", Steps/2)
