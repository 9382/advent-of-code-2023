--[==[ Post-Completion Explanation
We go through each line of our input and store a map of where the left and right go for each location.
Then we just apply this map to our starting position of AAA until we reach ZZZ. Not much else to it
]==]
local Input = io.open("input.txt", "r")

local DirectionOrder = Input:read("*l")
Input:read("*l") --dodge useless newline
local line = Input:read("*l")
local NodePaths = {}
while line do
	local Node, LeftPath, RightPath = line:match("(%w+) = %((%w+), (%w+)%)")
	NodePaths[Node] = {L=LeftPath, R=RightPath}
	line = Input:read("*l")
end

local Iterations = 0
local CurNode = "AAA"
while CurNode ~= "ZZZ" do
	local Instruction = (Iterations%#DirectionOrder)+1
	Iterations = Iterations + 1
	local Direction = DirectionOrder:sub(Instruction, Instruction)
	CurNode = NodePaths[CurNode][Direction]
end
print("Iterations:", Iterations)
