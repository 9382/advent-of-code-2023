Input = open("input.txt", "r").read()

# First, expand the universe. Then, start doing unit distances
ColumnsWithData = set()
RowsWithData = set()
SpaceMap = []
Lines = Input.split("\n")
Galaxies = []

# Pass 1: gather the data
for row in range(len(Lines)):
	line = Lines[row]
	if line == "":
		continue
	RowData = []
	for column in range(len(line)):
		char = line[column]
		if char == "#":
			RowsWithData.add(row)
			ColumnsWithData.add(column)
			Galaxies.append([column, row])
		RowData.append(char)
	SpaceMap.append(RowData)

def SmallerFirst(n1, n2):
	return (n1, n2) if n1 < n2 else (n2, n1)

# Since we are now adding millions of rows, we simply remember where we add and figure it out each time
Total = 0
for i in range(len(Galaxies)):
	G1 = Galaxies[i]
	for j in range(i+1, len(Galaxies)):
		G2 = Galaxies[j]
		SmallX, BigX = SmallerFirst(G1[0], G2[0])
		SmallY, BigY = SmallerFirst(G1[1], G2[1])
		DistanceOffset = 0
		# repeated iteration is a bit lame and slow but whatever
		for x in range(SmallX+1, BigX):
			if x not in ColumnsWithData:
				DistanceOffset += 1000000 - 1
		for y in range(SmallY+1, BigY):
			if y not in RowsWithData:
				DistanceOffset += 1000000 - 1
		Total = Total + (BigX - SmallX) + (BigY - SmallY) + DistanceOffset

print("Total of distances:", Total)
