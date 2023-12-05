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
		SeedRanges = line[7:].split(" ")
		SeedsToPlant = []
		while len(SeedRanges) > 0:
			SeedStart, SeedRange = SeedRanges[:2]
			SeedsToPlant.append([int(SeedStart), int(SeedRange)])
			SeedRanges = SeedRanges[2:]
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
# We have to track ranges instead of exact numbers for the seeds since the scale is so large
""" Post-completion explanation
Instead of storing each seed number like we did in version 1 where it was viable, here we store ranges of seeds
We apply each of the mapping ranges to each seed range
Since we know no maps overlap, the maps loop goes over the range loop

If only part of the seed range is captured by a map's range, we translate just the section that got caught
We then take the uncaught sections and put them back into the Ranges table
this is so that the next map range will still apply to uncaught areas.

Any translated area gets put into NextRanges instead, a holding ground of already-modified ranges
Any range that wasn't caught is left unmodified, so we can just extend NextRanges by whatever was left over at the end

For calculating the lowest index, we just take when each range starts, since every range is from X onwards. Rather simple compared to what just came before it
"""
LowestIndex = 9e9
for SeedStart, SeedRange in SeedsToPlant:
	Ranges = [[SeedStart, SeedRange]]
	for Map in TraversalOrder:
		NextRanges = []
		for MapDestination, MapSource, MapRange in FinalMappingData[Map]:
			for Range in list(Ranges):
				RangeStart, RangeRange = Range # RangeRange goes hard
				IsInsideMapStart = MapSource <= RangeStart
				IsInsideMapFinish = RangeStart+RangeRange <= MapSource+MapRange #the expected "-1" cancels
				IsNotWithinBounds = RangeStart+RangeRange < MapSource or RangeStart > MapSource+MapRange-1

				# print("Case N", "Range", RangeStart, RangeRange, "Map", MapSource, MapDestination, MapRange)
				if IsNotWithinBounds:
					# Case 0: The seed range doesn't meet the map range at all (no overlap)
					pass
				elif IsInsideMapStart and IsInsideMapFinish:
					# Case 1: Seed range is entirely captured by map range
					NextRanges.append([RangeStart-(MapSource-MapDestination), RangeRange])
					Ranges.remove(Range)
				elif not IsInsideMapStart and IsInsideMapFinish:
					# Case 2: The seed range begins before the map range but ends in it
					NextRanges.append([MapDestination, RangeRange-(MapSource-RangeStart)])
					Ranges.append([RangeStart, MapSource-RangeStart])
					Ranges.remove(Range)
				elif IsInsideMapStart and not IsInsideMapFinish:
					# Case 3: The seed range begins in the map range but ends after it (off by 1 error incoming)
					NextRanges.append([RangeStart-(MapSource-MapDestination), MapRange-(RangeStart-MapSource)])
					Ranges.append([MapSource+MapRange, RangeStart+RangeRange-(MapSource+MapRange)])
					Ranges.remove(Range)
				elif not IsInsideMapStart and not IsInsideMapFinish:
					# Case 4: The seed range begins before the map range and ends after it
					NextRanges.append([MapDestination, MapRange-(RangeStart-MapSource)])
					Ranges.append([RangeStart, MapSource-RangeStart])
					Ranges.append([MapSource+MapRange, RangeStart+RangeRange-(MapSource+MapRange)])
					Ranges.remove(Range)

		# print("Left-overs who never met a range:", len(Ranges))
		NextRanges.extend(Ranges)
		Ranges = NextRanges
		NextRanges = []
	LowestSeen = 9e9
	# print("Testing", len(Ranges), "ranges")
	for Range in Ranges:
		LowestSeen = min(LowestSeen, Range[0])
	print("Lowest seen in seed's ranges", LowestSeen)
	LowestIndex = min(LowestIndex, LowestSeen)
print("Lowest location number:", LowestIndex)
