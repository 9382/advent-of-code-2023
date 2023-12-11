Input = open("input.txt", "r").read()

# First, expand the universe. Then, start doing unit distances
ColumnsWithData = set()
RowsWithData = set()
SpaceMap = []
Lines = Input.split("\n")
# RowLength = len(Lines[0])

# Pass 1: gather the data
for row in range(len(Lines)):
	line = Lines[row]
	if line == "":
		continue
	RowData = []
	# SpaceMap.append(line)
	for column in range(len(line)):
		char = line[column]
		if char == "#":
			RowsWithData.add(row)
			ColumnsWithData.add(column)
		RowData.append(char)
	SpaceMap.append(RowData)

# Pass 2: expand our map (we modify data lengths so go in reverse)
for row in range(len(SpaceMap)-1, -1, -1): # I love python ranges
	if row not in RowsWithData:
		SpaceMap.insert(row, list(SpaceMap[row])) # we list() it since having an exact copy can be risky if we need to change stuff later
for row in SpaceMap:
	for column in range(len(row)-1, -1, -1):
		if column not in ColumnsWithData:
			row.insert(column, ".")

# Pass 3: Get coordinates of every galaxy
Galaxies = []
for row in range(len(SpaceMap)):
	RowData = SpaceMap[row]
	for column in range(len(RowData)):
		if RowData[column] == "#":
			Galaxies.append([column, row]) # [x, y]

Total = 0
for i in range(len(Galaxies)):
	G1 = Galaxies[i]
	for j in range(i+1, len(Galaxies)):
		G2 = Galaxies[j]
		Total = Total + abs(G1[0] - G2[0]) + abs(G1[1] - G2[1])

print("Total of distances:", Total)
