""" Post-Completion Explanation
Here we do the inverse of part 1, kinda
First, we form a grid map, but instead of the original data, each spot contains the entire result of a number if it occupied that space with any digit.
Then, we re-traverse the original grid, and for every gear (*) we find, we check all 8 squares around the grid.
If we find a regex match, we add it to our "adjacent" set, and then add up the values in the set after checking all the squares

Here, we use the fact that sets can't contain duplicate values to make our job much easier,
as in cases where a number was adjacent to a gear more than once are handled automatically by how the set works.
"""
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