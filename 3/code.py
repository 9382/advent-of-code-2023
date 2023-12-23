""" Post-Completion Explanation
Find each set of numbers, and then check every square around it for a symbol.
the `i > 0` and `i < len(Rows)-1` checks are just safety to avoid exiting the bounds of our grid
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
""" #502 total
def IsSymbol(row, index):
	return index >= 0 and index < len(row) and (x := row[index]) != "" and re.search("[^0-9.]", x)
Total = 0
for i in range(len(Rows)):
	row = Rows[i]
	for number in re.finditer("\d+", row):
		start, end = number.span()
		if IsSymbol(row, start-1) or IsSymbol(row, end): #Adjacent in-row
			Total = Total + int(number.group())
			continue
		if i > 0: #Adjacent in above row
			for j in range(start-1, end+1):
				if IsSymbol(Rows[i-1], j):
					Total = Total + int(number.group())
					continue
		if i < len(Rows)-1: #Adjacent in below row
			for j in range(start-1, end+1):
					if IsSymbol(Rows[i+1], j):
						Total = Total + int(number.group())
						continue

print("Total:", Total)