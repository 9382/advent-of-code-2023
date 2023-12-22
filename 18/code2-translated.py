# [!] INVALID SOLUTION: THIS SCRIPT WILL GENERATE THE WRONG SOLUTION [!]
Input = open("input.txt", "r").read()

""" Part 2 comments
This is a python translation of the associated lua file
I've translated it to python in the hope of getting past the Out-Of-Memory issue
(Yes, I'm trying to beat that issue by changing language. Top-tier laziness)
WARNING: USES 12GB OF RAM AT PEAK
THIS IS NOT A JOKE
"""
NORTH, EAST, SOUTH, WEST = 0, 1, 2, 3
LRPoint = 0
UDPoint = 0
LowestX, HighestX = 0, 0
LowestY, HighestY = 0, 0
Sequence = []
import re
for line in Input.split("\n"):
	if line == "":
		continue
	Dir, Distance, Paint = re.search("^([URDL]) (\d+) \(#([0-9a-f]+)\)", line).groups()
	Distance, Dir = int(Paint[:5], 16), int(Paint[5])
	# Dir = ({"U":NORTH, "R":EAST, "D":SOUTH, "L":WEST})[Dir]
	# Distance = int(Distance)
	Sequence.append([Dir, Distance])
	LRPoint = LRPoint - (Dir-2)*(Dir%2)*Distance
	UDPoint = UDPoint + (Dir-1)*((Dir+1)%2)*Distance
	LowestX = min(LRPoint, LowestX)
	HighestX = max(LRPoint, HighestX)
	LowestY = min(UDPoint, LowestY) # LowestY is actually the most NORTH we get, because yes
	HighestY = max(UDPoint, HighestY)

X, Y = -LowestX, -LowestY
RowLength = HighestX-LowestX+1
ColumnLength = HighestY-LowestY+1
print(f"Size: {RowLength}X by {ColumnLength}Y")

print("Creating column rows...")
ColumnChanges = []
for i in range(RowLength):
	ColumnChanges.append({"Vals":[]})

print("Running sequences...")
i = 0
for Dir, Distance in Sequence:
	i = i + 1
	print(i, "/", len(Sequence))
	if (Dir%2) == 0: # North/South
		Changes = ColumnChanges[X]
		for j in range(Distance):
			Y = Y + (Dir-1)
			Changes[Y] = Y
			Changes["Vals"].append(Y)
	else: # East/West
		for j in range(Distance):
			X = X - (Dir-2)
			Changes = ColumnChanges[X]
			Changes[Y] = Y
			Changes["Vals"].append(Y)

def quickin(obj, container):
	try:
		return container[obj] or True
	except:
		return False

print("Calculating internal area...")
InsideSize = 0
for i in range(RowLength):
	ColumnData = ColumnChanges[i]
	Values = ColumnData["Vals"]
	Values.sort()
	CurrentlyInside = False
	PrevValue = 0
	j = 0
	if i >= 2:
		ColumnChanges[i - 2] = None # give me my memory back
	while j < len(Values): # not a standard for j in range loop since I need variable modification
		# this is an absolute mess of a mix of values and not values but its whatever since it works
		if quickin(Values[j]+1, ColumnData): # Vertical movement (complex)
			k = Values[j]+1
			while quickin(k+1, ColumnData):
				k = k + 1
			k = k - Values[j] + j
			TargetX = (i == 0 and i + 1 or i - 1)
			if quickin(Values[j], ColumnChanges[TargetX]) == quickin(Values[k], ColumnChanges[TargetX]): # we enter the way we exit, inside status is unchanged
				if not CurrentlyInside:
					InsideSize = InsideSize + (k - j + 1)
			else: # we have gone from inside to outside or vice versa
				if CurrentlyInside: #exit at k
					InsideSize = InsideSize + (Values[k] - PrevValue + 1)
					PrevValue = Values[k] #doesnt really matter
				else: #enter at j
					PrevValue = Values[j]
				CurrentlyInside = not CurrentlyInside
			j = k
		else: # Horizontal movement (simple)
			if CurrentlyInside:
				InsideSize = InsideSize + (Values[j] - PrevValue + 1)
			CurrentlyInside = not CurrentlyInside
			PrevValue = Values[j]
		j = j + 1

print("Inside size:", InsideSize)
