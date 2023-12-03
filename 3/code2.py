Input = open("Input.txt", "r").read()
# any number adjacent to a symbol, even diagonally
# diagonally? really? :)

import re
Rows = Input.split("\n")
# Rows = ["467..114..", "...*......", "..35..633."]
"""
467..114..
...*......
..35..633.
""" #16345 total expected

# Calculate a useful reference table to every unique number occurance
NumberMatrix = [None]*len(Rows)
for i in range(len(Rows)):
	row = Rows[i]
	RowData = [None]*len(row)
	for number in re.finditer("\d+", row):
		start, end = number.span()
		for j in range(start, end):
			RowData[j] = number
	NumberMatrix[i] = RowData

# Now find each "gear" and get its number data
Total = 0
for i in range(len(Rows)):
	row = Rows[i]
	for j in range(len(row)):
		if row[j] == "*":
			adjacent = set()
			for x in [j-1, j, j+1]:
				for y in [i-1, i, i+1]: # so much depth but whatever
					if 0 <= x < len(row) and 0 <= y < len(Rows):
						adjacent.add(NumberMatrix[y][x])
			if None in adjacent:
				adjacent.remove(None)
			if len(adjacent) == 2:
				n1, n2 = adjacent
				Total = Total + (int(n1.group()) * int(n2.group()))

print("Total:", Total)