""" Post-Completion Explanation
A translation of code2.lua into python, done just to test the process. Nothing important to note here
"""
Input = open("input.txt", "r").read()

import re
Lines = Input.split("\n")
Total = 0
BonusCards = [0]*(len(Lines)+5) #+5 is for safety buffer towards the end
for line in Lines:
	if line == "":
		continue
	CardN, Winners, Numbers = re.search("^Card +(\d+): ([^|]+) \| (.+)$", line).groups()
	CardN = int(CardN)-1
	ExtraCopies = BonusCards[CardN]
	WinningNumbers = set()
	Matches = 0
	for number in re.findall("\d+", Winners):
		WinningNumbers.add(number)
	for number in re.findall("\d+", Numbers):
		if number in WinningNumbers:
			Matches = Matches + 1
	for i in range(1, Matches+1): #cringe python ranges, this is why lua is better (sometimes)
		BonusCards[CardN+i] = BonusCards[CardN+i] + 1+ExtraCopies
	Total = Total + 1 + ExtraCopies

print("Total:", Total)
