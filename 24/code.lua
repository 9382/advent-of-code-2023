--[==[ Post-Completion Explanation
This is mostly just a test of math skills more than anything else
Find when 2 lines intersect, figure out if both are in the future and in the test zone, note valid cases
We define our own vector "class" (this is lua, classes are an improvisation) for convenience
]==]
local Input = io.open("input.txt", "r")

-- As close as lua gets to a "class" (of all days to not use python)
local Vector3 = {}
Vector3.__index = Vector3
function Vector3:__tostring()
	return self.X .. ", " .. self.Y .. ", " .. self.Z
end
function Vector3:__add(vector)
	return Vector3.new(self.X+vector.X, self.Y+vector.Y, self.Z+vector.Z)
end
function Vector3:__sub(vector)
	return Vector3.new(self.X-vector.X, self.Y-vector.Y, self.Z-vector.Z)
end
function Vector3.__mul(o1, o2)
	local self, num = o1, o2
	if type(o2) == "table" then
		self, num = o2, o1
	end
	return Vector3.new(self.X*num, self.Y*num, self.Z*num)
end
function Vector3.new(x, y, z)
	local magnitude = (x^2 + y^2 + z^2)^.5
	local Vector = setmetatable({X=x, Y=y, Z=z, Magnitude=magnitude}, Vector3)
	--[[ unused
	if Vector.Magnitude ~= 1 then
		Vector.Unit = Vector3.new(x/Vector.Magnitude, y/Vector.Magnitude, z/Vector.Magnitude)
	else
		Vector.Unit = Vector -- mmmmm dunno how I feel about this but it'll do
	end
	]]
	return Vector
end
function Vector3:Dot(vector) --unused but whatever
	return self.X*vector.X + self.Y*vector.Y + self.Z*vector.Z
end

local Vectors = {}
local line = Input:read("*l")
while line do
	local PX, PY, PZ, VX, VY, VZ = line:match("(%-?%d+), +(%-?%d+), +(%-?%d+) +@ +(%-?%d+), +(%-?%d+), +(%-?%d+)")
	PX, PY, PZ, VX, VY, VZ = tonumber(PX), tonumber(PY), tonumber(PZ), tonumber(VX), tonumber(VY), tonumber(VZ)
	PZ, VZ = 0, 0 --condition of part 1
	local PositionVector = Vector3.new(PX, PY, PZ)
	local VelocityVector = Vector3.new(VX, VY, VZ)
	Vectors[#Vectors+1] = {Position=PositionVector, Velocity=VelocityVector}
	line = Input:read("*l")
end

local TestingMin = 200000000000000
local TestingMax = 400000000000000
local Successes = 0
-- every pair
print("Calculating every pair's intersection")
for i = 1, #Vectors do
	local Obj1 = Vectors[i]
	local P1, V1 = Obj1.Position, Obj1.Velocity
	for j = i+1, #Vectors do
		local Obj2 = Vectors[j]
		local P2, V2 = Obj2.Position, Obj2.Velocity
		if V1.X/V2.X == V1.Y/V2.Y then
			-- Vectors are parallel, no way they meet
		else
			--P1 + p(V1) == P2 + q(V2)
			--form a simul equation (see really really bad theory.png for how - its using a 2x2 matrix)
			local InvDeterminant = 1/(V1.X*(-V2.Y) - V1.Y*(-V2.X))
			local PXdiff = P2.X - P1.X
			local PYdiff = P2.Y - P1.Y
			local p = InvDeterminant * (-V2.Y*PXdiff + V2.X*PYdiff)
			local q = InvDeterminant * (-V1.Y*PXdiff + V1.X*PYdiff)
			if p >= 0 and q >= 0 then --no backwards time travelling
				local NewPosition = P1 + p*V1 --doesnt matter which we use
				if NewPosition.X >= TestingMin and NewPosition.X <= TestingMax then
					if NewPosition.Y >= TestingMin and NewPosition.Y <= TestingMax then
						Successes = Successes + 1
					end
				end
			end
		end
	end
end
print("Total intersections within the test area:", Successes)
