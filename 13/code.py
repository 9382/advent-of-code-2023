""" Post-Completion Explanation
We go through each grid and attempt to find a reflection
An easy way to tell when we might be expecting a reflection is when 2 rows or 2 columns in a row have the same data.
From here, we expand on outwards, and if we continue to match the entire way, we've found our reflection.
We actually support the ability to find both a column and grid reflection, and multiple of them, but I'm not sure if this ever happens in the test cases
"""
Input = open("input.txt", "r").read()

def SolveGridReflections(GridRows):
	GridTotal = 0
	# Look for row reflections
	GridColumns = []
	for x in range(len(GridRows[0])):
		GridColumns.append("") # Prepare columns row
	for y in range(len(GridRows)):
		for x in range(len(GridRows[y])):
			GridColumns[x] += GridRows[y][x]
		if y > 0 and GridRows[y] == GridRows[y-1]:
			IsAReflection = True
			for i in range(1, len(GridRows)-y):
				if y-i > 0 and GridRows[y+i] != GridRows[y-i-1]:
					IsAReflection = False
					break
			if IsAReflection:
				GridTotal = GridTotal + 100*y
	# Look for column reflections
	for x in range(len(GridColumns)):
		if x > 0 and GridColumns[x] == GridColumns[x-1]:
			IsAReflection = True
			for i in range(1, len(GridColumns)-x):
				if x-i > 0 and GridColumns[x+i] != GridColumns[x-i-1]:
					IsAReflection = False
					break
			if IsAReflection:
				GridTotal = GridTotal + x
	return GridTotal

Total = 0
CurrentGrid = []
for line in Input.split("\n"):
	if line == "":
		Total = Total + SolveGridReflections(CurrentGrid)
		CurrentGrid = []
	else:
		CurrentGrid.append(line)

print("Total:", Total)
