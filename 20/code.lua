local Input = io.open("input.txt", "r")

print("Collecting instructions...")
local LOW, HIGH = 0, 1
local FlipFlops = {}
local Conjunctions = {}
local BroadcasterTargets = {}
local line = Input:read("*l")
while line do
	local type = line:sub(1, 1)
	if type == "%" then --flip-flop
		local Name, TargetString = line:match("^%%(%w+) %->( .+)")
		local Targets = {}
		for match in TargetString:gmatch(" (%w+)") do
			Targets[#Targets+1] = match
		end
		FlipFlops[Name] = {Targets=Targets, State=LOW}
	elseif type == "&" then --conjunction
		local Name, TargetString = line:match("^&(%w+) %->( .+)")
		local Targets = {}
		for match in TargetString:gmatch(" (%w+)") do
			Targets[#Targets+1] = match
		end
		Conjunctions[Name] = {Targets=Targets, Memory={}}
	else --broadcaster
		for match in line:gmatch(" (%w+)") do --simple and barely valid regex
			BroadcasterTargets[#BroadcasterTargets+1] = match
		end
	end
	line = Input:read("*l")
end

for _,TargetSet in next,{FlipFlops, Conjunctions, {{Targets=BroadcasterTargets}}} do
	for Name,Obj in next,TargetSet do
		for _,Target in next,Obj.Targets do
			if Conjunctions[Target] then
				Conjunctions[Target].Memory[Name] = LOW
			end
		end
	end
end

local function HandleFlipFlop(Signal)
	local Data = FlipFlops[Signal.Target]
	if not Data then
		return
	end
	local NewPulses = {}
	if Signal.Type == LOW then
		Data.State = (Data.State+1)%2
		for _,Target in next,Data.Targets do
			NewPulses[#NewPulses+1] = {Type=Data.State, Target=Target, Origin=Signal.Target}
		end
	end
	return NewPulses
end

local function HandleConjunction(Signal)
	local Data = Conjunctions[Signal.Target]
	if not Data then
		return
	end
	Data.Memory[Signal.Origin] = Signal.Type
	local NewPulses = {}
	local IsAllHigh = true
	for Origin, LastType in next, Data.Memory do
		if LastType ~= HIGH then
			IsAllHigh = false
			break
		end
	end
	for _,Target in next,Data.Targets do
		NewPulses[#NewPulses+1] = {Type=not IsAllHigh and HIGH or LOW, Target=Target, Origin=Signal.Target}
	end
	return NewPulses
end

local function PressButton()
	local ActiveSignals = {}
	local LowPulses, HighPulses = 1, 0
	for _,Target in next,BroadcasterTargets do
		ActiveSignals[#ActiveSignals+1] = {Type=LOW, Target=Target, Origin="broadcaster"}
		LowPulses = LowPulses + 1
	end
	while #ActiveSignals > 0 do
		local NewSignals = {}
		for _,Signal in next,ActiveSignals do
			-- print("Send out to", Signal.Target, "with strength", Signal.Type)
			local Results = HandleFlipFlop(Signal) or HandleConjunction(Signal) or {}
			for i = 1, #Results do
				if Results[i].Type == LOW then
					LowPulses = LowPulses + 1
				else
					HighPulses = HighPulses + 1
				end
				NewSignals[#NewSignals+1] = Results[i]
			end
		end
		ActiveSignals = NewSignals
	end
	return LowPulses, HighPulses
end

print("Pressing buttons...")
local LowPulses, HighPulses = 0, 0
for i = 1, 1000 do
	local L, H = PressButton()
	LowPulses = LowPulses + L
	HighPulses = HighPulses + H
end
print("Low and High:", LowPulses, HighPulses)
print("Value total:", LowPulses * HighPulses)
