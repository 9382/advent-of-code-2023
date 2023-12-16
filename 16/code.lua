local Input = io.open("input.txt", "r")

local TileMapping = {}
local TraversedSquares = {}
local RowLength
local line = Input:read("*l")
while line do
	local RowData = {}
	RowLength = #line
	for i = 1, #line do
		RowData[i] = line:sub(i, i)
	end
	TileMapping[#TileMapping+1] = RowData
	TraversedSquares[#TraversedSquares+1] = {} --for later
	line = Input:read("*l")
end

local NORTH, EAST, SOUTH, WEST = 1, 2, 3, 4
local Lasers = {{Dir=EAST, X=0, Y=1}} --0 since we move into the board
local SeenLaserStates = {} --infinite loop avoider
local function HashLaserState(Laser)
	return Laser.Dir .. "|" .. Laser.X .. "|" .. Laser.Y
end
local function PrintTileMapping()
	local s = ""
	for y = 1, #TileMapping do
		for x = 1, #TileMapping[y] do
			if TraversedSquares[y][x] then
				s = s .. "#"
			else
				s = s .. TileMapping[y][x]
			end
		end
		s = s .. "\n"
	end
	print(s)
end
while #Lasers > 0 do
	for i = #Lasers, 1, -1 do --inverse order since we may remove or add lasers at any time
		local Laser = Lasers[i]
		-- move the laser
		if Laser.Dir == NORTH then
			Laser.Y = Laser.Y - 1
		elseif Laser.Dir == EAST then
			Laser.X = Laser.X + 1
		elseif Laser.Dir == SOUTH then
			Laser.Y = Laser.Y + 1
		elseif Laser.Dir == WEST then
			Laser.X = Laser.X - 1
		end
		LaserHash = HashLaserState(Laser)
		if Laser.X <= 0 or Laser.Y <= 0 or Laser.X > RowLength or Laser.Y > #TileMapping or SeenLaserStates[LaserHash] then
			table.remove(Lasers, i)
		else
			SeenLaserStates[LaserHash] = true
			TraversedSquares[Laser.Y][Laser.X] = true
			local TouchedObject = TileMapping[Laser.Y][Laser.X]
			if TouchedObject == "\\" then
				Laser.Dir = ({[NORTH]=WEST, [EAST]=SOUTH, [SOUTH]=EAST, [WEST]=NORTH})[Laser.Dir]
			elseif TouchedObject == "/" then
				Laser.Dir = ({[NORTH]=EAST, [EAST]=NORTH, [SOUTH]=WEST, [WEST]=SOUTH})[Laser.Dir]
			elseif TouchedObject == "-" then
				if Laser.Dir == NORTH or Laser.Dir == SOUTH then
					Laser.Dir = EAST
					Lasers[#Lasers+1] = {Dir=WEST, X=Laser.X, Y=Laser.Y}
				end
			elseif TouchedObject == "|" then
				if Laser.Dir == EAST or Laser.Dir == WEST then
					Laser.Dir = NORTH
					Lasers[#Lasers+1] = {Dir=SOUTH, X=Laser.X, Y=Laser.Y}
				end
			end
		end
	end
	--PrintTileMapping(); for i = 1,1e8 do end
end

local EnergisedSquares = 0
for y = 1, #TileMapping do
	for x = 1, #TileMapping[y] do
		if TraversedSquares[y][x] then
			EnergisedSquares = EnergisedSquares + 1
		end
	end
end

PrintTileMapping()

print("Energised squares:", EnergisedSquares)
