--[==[ Post-Completion Explanation
An alternative solution to part 2 which uses maths instead of iteration to get our answer - much faster
]==]
local Input = io.open("input.txt", "r")

local Time = tonumber(Input:read("*l"):sub(11, -1):gsub(" ", ""), 10)
local Distance = tonumber(Input:read("*l"):sub(11, -1):gsub(" ", ""), 10)
print("Time", Time, "Distance", Distance)
-- Given T time, pass D distance
-- If we pause for N time, we expect to go N*(T-N) distance
-- We need to find the bounds for N when T and D are known
--[[
N(T-N) > D
-N^2 + TN - D > 0 --Quadratic
N^2 - TN + D < 0
When do we equal 0?
(-b +- sqrt(b^2 - 4ac))/(2a)
(T +- sqrt(T^2 - 4D))/2
gives us our roots - adjust to first successes and we're done
--]]
local QuadraticRoot = math.sqrt(Time^2 - 4*Distance)/2
local EarliestSuccess = math.ceil(Time/2 - QuadraticRoot)
local LatestSuccess = math.floor(Time/2 + QuadraticRoot)
print("Earliest", EarliestSuccess, "Latest", LatestSuccess)
print("Total:", LatestSuccess - EarliestSuccess + 1)

