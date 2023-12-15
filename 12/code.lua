local Input = io.open("input.txt", "r")

local function L1Copy(t, b)
	b = b or {}
	for x,y in next,t do
		b[x] = y
	end
	return b
end

local function GetSolutionsForSegment(Segment, Groups)
	local Total = 0
	local PotentialChanges = {}
	local OriginalIndexableString = {} -- I can't think straight at 6am
	local Hashtags = 0
	for i = 1, #Segment do
		local char = Segment:sub(i,i)
		if char == "?" then
			PotentialChanges[#PotentialChanges+1] = i
		elseif char == "#" then
			Hashtags = Hashtags + 1
		end
		OriginalIndexableString[#OriginalIndexableString+1] = char
	end
	local GroupTotal = 0
	for _,v in next,Groups do
		GroupTotal = GroupTotal + v
	end
	local RequiredChanges = GroupTotal - Hashtags
	if RequiredChanges == #PotentialChanges or RequiredChanges == 0 then
		return 1
	end
	-- NOTE: The below has since been implemented (22.5x better on entire dataset, wow)
	-- TODO: REDUCE TOTAL ITERATION COUNT VIA SMART FOR LOOPS
	-- ITS WAYYYY CHEAPER THAN 2^x
	-- (ok by way cheaper its turning 2^x into a single binomial slice of (1+1)^x)
	-- (e.g. if x=20 and we had worst case (10 pending), we would still go from 1048576 iterations to just 184756)
	-- (aka its probably always at least an order of magnitude better to do this diff method)
	local SetOfNumbers = {}
	for i = 1, RequiredChanges do
		SetOfNumbers[i] = i
	end
	local GetReadyToBreak = false
	while true do
		local IndexableString = L1Copy(OriginalIndexableString)
		-- first, test it
		for _,v in next,SetOfNumbers do
			IndexableString[PotentialChanges[v]] = "#"
		end
		local str = table.concat(IndexableString, ""):gsub("%?", ".")
		local IsValid = true
		local i = 1
		for Segment in str:gmatch("([^.]+)%.*") do
			if Groups[i] ~= #Segment then
				IsValid = false
				break
			end
			i = i + 1
		end
		if IsValid and i-1 == #Groups then
			Total = Total + 1
		end
		if GetReadyToBreak then break end
		-- then advance... somehow
		SetOfNumbers[#SetOfNumbers] = SetOfNumbers[#SetOfNumbers] + 1
		for i = #SetOfNumbers, 1, -1 do
			if SetOfNumbers[i] > #PotentialChanges-(#SetOfNumbers-i) then
				SetOfNumbers[i-1] = SetOfNumbers[i-1] + 1
				SetOfNumbers[i] = SetOfNumbers[i-1] + 1
				for j = i+1, #SetOfNumbers do
					SetOfNumbers[j] = SetOfNumbers[j-1] + 1 --????
				end
			end
		end
		GetReadyToBreak = SetOfNumbers[1] >= (#PotentialChanges - #SetOfNumbers + 1) -- I hate this
	end
	return Total
end

local function AttemptToSolve(Data, Groups)
	local PositionByCharacter = {["."]={}, ["?"]={}, ["#"]={}}
	local IndexableString = {} -- I can't think straight at 6am
	for i = 1, #Data do
		local char = Data:sub(i,i)
		IndexableString[#IndexableString+1] = char
		PositionByCharacter[char][#PositionByCharacter[char]+1] = i
	end
	-- do some incredibly basic solving (this is messy as hell but does manage to partially solve)
	---[==[
	local Potential = #PositionByCharacter["?"] + #PositionByCharacter["#"]
	local GroupTotal = 0
	for _,v in next,Groups do
		GroupTotal = GroupTotal + v
	end
	local HashStart, _, FirstHashGroup = Data:find("(#+)")
	HashStart = HashStart or 9e9
	local UnkStart, _, FirstUnkGroup = Data:find("(%?+)")
	UnkStart = UnkStart or 9e9
	if HashStart < UnkStart then -- we start with a hash
		local HahaYouHaveAPeriod = Data:sub(HashStart, HashStart+Groups[1]-1):find("%.")
		if HahaYouHaveAPeriod then
			Data = Data:sub(1, HashStart-1) .. string.rep(".", HahaYouHaveAPeriod-1) .. Data:sub(HashStart+HahaYouHaveAPeriod, -1)
		end
	elseif UnkStart < HashStart then -- we dont start with a hash (shocker)
		local HahaYouHaveAPeriod = Data:sub(UnkStart, UnkStart+Groups[1]-1):find("%.")
		if HahaYouHaveAPeriod then
			Data = Data:sub(1, UnkStart-1) .. string.rep(".", HahaYouHaveAPeriod-1) .. Data:sub(UnkStart+HahaYouHaveAPeriod, -1)
		end
	else
		print("SPACE TIME LAWS HAVE BEEN VIOLATED", Data, Groups) --just having a bit of fun
	end
	Data = Data:gsub("%.%.+", ".")
	--]==]
	-- then just guess
	return GetSolutionsForSegment(Data, Groups)
end

local line = Input:read("*l")
local Total = 0
local start = os.clock()
local ProgressTrack = 1
while line do
	if ProgressTrack % 50 == 0 then
		print(ProgressTrack .. " / 1000")
	end
	local Segments = {}
	local Data, Groups = line:match("(.+) (.+)")
	Data = Data:gsub("%.%.+", ".") --remove excessive periods
	local GroupData = {}
	for term in Groups:gmatch("[^,]+") do
		GroupData[#GroupData+1] = tonumber(term)
	end
	-- How the hell do I wanna do this?
	Total = Total + AttemptToSolve(Data, GroupData)
	line = Input:read("*l")
	ProgressTrack = ProgressTrack + 1
end

print("Time taken:", os.clock()-start)
print("Total:", Total)
