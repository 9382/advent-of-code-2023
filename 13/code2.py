""" Post-Completion Explanation
Here we use the same solution as in part 1, except this time, we expect a smudge.
That means, for every row and column, we find how many "differences" each side has.
If the entire reflection only ever has 1 difference, then that means it has a singular "smudge" and is our target reflection
The input data is very generous here as there's guaranteed to just be apparently 1 smudge, which lets us get away with some rather simple code
"""
Input = open("input.txt", "r").read()

def DetermineDifference(R1, R2):
	Differences = 0
	for i in range(len(R1)):
		if R1[i] != R2[i]:
			Differences = Differences + 1
			if Differences >= 2: # We only care if there are 0, 1, or 2+
				break
	return Differences

def Transpose(Rows):
	Columns = []
	for x in range(len(Rows[0])):
		Columns.append("")
	for y in range(len(Rows)):
		for x in range(len(Rows[y])):
			Columns[x] += Rows[y][x]
	return Columns

# Any smudged reflection will have exactly 1 fail throughout it, so we look for a case where that happens
# Thankfully, the input data always only has 1 case of this, so we don't have to do some weird special find-all-cases stuff
def SolveWithSmudges(GridRows):
	# Look for row reflections
	for y in range(len(GridRows)):
		if y > 0:
			Differences = DetermineDifference(GridRows[y], GridRows[y-1])
			for i in range(1, len(GridRows)-y):
				if y-i > 0:
					Differences = Differences + DetermineDifference(GridRows[y+i], GridRows[y-i-1])
					if Differences >= 2:
						break
			if Differences == 1:
				return 100*y
	# Look for column reflections
	GridColumns = Transpose(GridRows)
	for x in range(len(GridColumns)):
		if x > 0:
			Differences = DetermineDifference(GridColumns[x], GridColumns[x-1])
			for i in range(1, len(GridColumns)-x):
				if x-i > 0:
					Differences = Differences + DetermineDifference(GridColumns[x+i], GridColumns[x-i-1])
					if Differences >= 2:
						break
			if Differences == 1:
				return x

Total = 0
CurrentGrid = []
for line in Input.split("\n"):
	if line == "":
		Total = Total + SolveWithSmudges(CurrentGrid)
		CurrentGrid = []
	else:
		CurrentGrid.append(line)

print("Total:", Total)
