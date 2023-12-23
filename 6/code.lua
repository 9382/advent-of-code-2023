--[==[ Post-Completion Explanation
Once again, rather simple.
We traverse forwards until we find our first working case and then backwards until we find out first (techincally last) working case
Then just figure out the difference and go from there
]==]
local Input = io.open("input.txt", "r")

local TimeData = Input:read("*l"):sub(11, -1):gmatch("[^ ]+")
local DistanceData = Input:read("*l"):sub(11, -1):gmatch("[^ ]+")
local Total = 1
while true do
	local Time, Distance = tonumber(TimeData() or ""), tonumber(DistanceData() or "")
	if not Time then
		break
	end
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
	Total = Total * (LatestSuccess - EarliestSuccess + 1)
	print("Earliest", EarliestSuccess, "Latest", LatestSuccess)
end
print("Total:", Total)
