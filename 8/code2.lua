--[==[ Post-Completion Explanation
We have to get a bit creative here. Since we have to find when every path is currently at a Z-ending node,
just iterating until this is the case is not viable, as if one took 1000 cycles, and another took 1001, you'd be waiting a LONG time.
Luckily, we can use the concept of a Lowest Common Multiple between 2 numbers to find the first time both of these conditions meet.
Therefore, we just track how long each node took individually (this isn't a complex calculation), and then find the LCM of them all
]==]
local Input = io.open("input.txt", "r")

local DirectionOrder = Input:read("*l")
Input:read("*l") --dodge useless newline
local line = Input:read("*l")
local NodePaths = {}
local CurNodes = {}
while line do
	local Node, LeftPath, RightPath = line:match("(%w+) = %((%w+), (%w+)%)")
	NodePaths[Node] = {L=LeftPath, R=RightPath}
	line = Input:read("*l")
	if Node:sub(3, 3) == "A" then
		CurNodes[#CurNodes+1] = Node
	end
end

-- Find the amount of iterations per node so we can perform a lowest common multiple on them
local IterationsPerNode = {}
for i,Node in next,CurNodes do
	print("Calculating node", Node)
	local Iterations = 0
	while Node:sub(3, 3) ~= "Z" do
		local Instruction = (Iterations%#DirectionOrder)+1
		Iterations = Iterations + 1
		local Direction = DirectionOrder:sub(Instruction, Instruction)
		Node = NodePaths[Node][Direction]
	end
	IterationsPerNode[i] = Iterations
end

-- Credit: Stack-Overflow and other sites
-- I'm not deriving a lowest common multiple algorithm from scratch
local function GreatestCommonDenominator(n1, n2)
	while n2 > 0 do
		n1, n2 = n2, n1 % n2
	end
	return n1
end
local function LowestCommonMultiple(n1, n2)
	return (n1 * n2) / GreatestCommonDenominator(n1, n2)
end

local LowestMultiple = 1
print("Calculating lowest common multiple of every iteration...")
for _,Iterations in next,IterationsPerNode do
	LowestMultiple = LowestCommonMultiple(LowestMultiple, Iterations)
end
print("Iterations:", LowestMultiple)
