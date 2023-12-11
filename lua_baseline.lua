local Input = io.open("input.txt", "r")

local line = Input:read("*l")
while line do
	line = Input:read("*l")
end
