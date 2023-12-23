--[==[ Post-Completion Explanation
Somehow simpler than part 2, since its just 1 number we work with for the Time and Distance
We manage to get away with using the same slow iteration method since our data isnt that absurdly large
]==]
local Input = io.open("input.txt", "r")

local Time = tonumber(Input:read("*l"):sub(11, -1):gsub(" ", ""), 10)
local Distance = tonumber(Input:read("*l"):sub(11, -1):gsub(" ", ""), 10)
print("Time", Time, "Distance", Distance)
local EarliestSuccess, LatestSuccess
for i = 0, Time do
	local ExpectedDistance = (Time-i)*(i)
	if ExpectedDistance > Distance then
		EarliestSuccess = i
		break
	end
end
for i = Time, 0, -1 do
	local ExpectedDistance = (Time-i)*(i)
	if ExpectedDistance > Distance then
		LatestSuccess = i
		break
	end
end
print("Earliest", EarliestSuccess, "Latest", LatestSuccess)
print("Total:", LatestSuccess - EarliestSuccess + 1)

