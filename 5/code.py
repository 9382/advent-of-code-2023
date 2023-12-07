Input = open("input.txt", "r").read()

# Step 1: Compile mapping data
import re
FinalMappingData = {}
TemporaryMappingData = []
CurrentMapData = None
for line in Input.split("\n"):
	if line == "":
		if CurrentMapData:
			if CurrentMapData.group() in FinalMappingData.keys():
				print("UH OH MULTIPLE DATA THINGS!") # The can-we-be-lazy check
			FinalMappingData[CurrentMapData.group()] = TemporaryMappingData
			TemporaryMappingData = []
			CurrentMapData = None
	if line.startswith("seeds: "):
		SeedsToPlant = line[7:].split(" ")
	elif (MapData := re.search("(\w+)-to-(\w+)", line)):
		CurrentMapData = MapData
	elif CurrentMapData:
		# Note: We can't just define the translation for each number - its way too expensive to iterate that many times
		# Instead we leave the range definitions and do <= x < checks to find the appropriate range later on
		Destination, Source, Range = line.split(" ")
		TemporaryMappingData.append([int(Destination), int(Source), int(Range)])
print("Mapping Data compiled")

# Step 2: Compile locations
TraversalOrder = ["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"]
LowestIndex = 9e9
for seed in SeedsToPlant:
	CurrentIndex = int(seed)
	for Map in TraversalOrder:
		for Destination, Source, Range in FinalMappingData[Map]:
			if Source <= CurrentIndex < Source+Range:
				CurrentIndex = CurrentIndex - (Source-Destination)
				break
	# print("seed", seed, "index", CurrentIndex)
	LowestIndex = min(LowestIndex, CurrentIndex)
print("Lowest location number:", LowestIndex)
