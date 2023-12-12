local Input = io.open("input.txt", "r")

-- This takes like a minute to execute, bad code!
local line = Input:read("*l")
local Total = 0
while line do
	local Segments = {}
	local Data, Groups = line:match("(.+) (.+)")
	Data = Data:match("^%.*(.+)%.*$"):gsub("%.%.+", ".") --remove excessive periods
	local GroupData = {}
	for term in Groups:gmatch("[^,]+") do
		GroupData[#GroupData+1] = tonumber(term)
	end
	-- How the hell do I wanna do this?
	-- I'll first want to try eliminate groups with no ambiguity (and their associated data... :) )
	-- Hell, do I even want to do that? Do I just get mega lazy and bruteforce stuff and see what part 2 wants?
	-- Screw it, bruteforce time, I can't grasp a cool way to do this right now
	-- some basic optimisation before we bruteforce
	local FirstChar = Data:sub(1, 1)
	if FirstChar == "#" then
		Data = string.rep("#", GroupData[1]) .. "." .. Data:sub(GroupData[1] + 2, -1)
	else --FirstChar == "?"
		for i = 1, GroupData[1] do
			local FollowingChar = Data:sub(i+1, i+1)
			if FollowingChar == "#" then -- Everything up to (and past!) current index must be #
				--[[ broken, e.g. on ?###? 3
				Data = string.rep("#", GroupData[1]) .. "." .. Data:sub(GroupData[1] + 2, -1)
				table.remove(GroupData, 1)
				break
				--]]
			elseif FollowingChar == "." and i ~= GroupData[1] then -- Everything up to current index must be .
				Data = string.rep(".", i+1) .. Data:sub(i + 2, -1)
				break
			end
		end
	end
	-- and now some cringe bruteforcing
	local PotentialChanges = {}
	local IndexableString = {} -- I can't think straight at 6am
	for i = 1, #Data do
		local char = Data:sub(i,i)
		if char == "?" then
			PotentialChanges[#PotentialChanges+1] = i
		end
		IndexableString[#IndexableString+1] = char
	end
	local function SomeBitThing(bignum, power) -- this is stupid
		local startpower = math.ceil(math.log(bignum)/math.log(2))
		for i = startpower, 0, -1 do
			if bignum - (2^i) > 0 then
				if power == i then
					return true
				end
				bignum = bignum - (2^i)
			end
		end
		return false
	end
	for i = 1, 2^#PotentialChanges do -- 2^x is not something I want to iterate man
		for j = 1, #PotentialChanges do
			IndexableString[PotentialChanges[j]] = (SomeBitThing(i, j-1) and "#" or ".")
		end
		local str = table.concat(IndexableString, "")
		local IsValid = true
		local i = 1
		for Segment in str:gmatch("([^.]+)%.*") do
			if GroupData[i] ~= #Segment then
				IsValid = false
				break
			end
			i = i + 1
		end
		if IsValid and i-1 == #GroupData then
			Total = Total + 1
		end
	end
	line = Input:read("*l")
end

print("Total:", Total)
