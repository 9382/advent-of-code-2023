""" Post-Completion Explanation
Rather simple this one, just go through each character, if its a digit, note it appropriately.
"""
InputData = open("input.txt", "r").read()
Total = 0
for line in InputData.split("\n"):
	if line == "":
		continue
	FirstNum, LastNum = None, None
	for c in line:
		if c in "0123456789":
			if FirstNum == None:
				FirstNum = c
			LastNum = c
	Total = Total + int(FirstNum + LastNum)
print("Total:", Total)
