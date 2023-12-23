""" Post-Completion Explanation
Basically the exact same. Only a few lines changed as we swapped from last to first (and from + to -). Nothing significant to note here
"""
Input = open("input.txt", "r").read()

def CalculateNextExpectedChange(Sequence):
	FirstValue = int(Sequence[0])
	SubSequence = []
	IsAllZero = True
	for i in range(len(Sequence)-1):
		NextValue = int(Sequence[i+1]) - int(Sequence[i])
		if NextValue != 0:
			IsAllZero = False
		SubSequence.append(NextValue)
	if IsAllZero: # The sequence has no changes (our rate of change is consistent), send up the consistent change
		return FirstValue
	else: # The sequence has a predicted rate of change of whatever the subsequence resolves to, so adjust our first value by that amount
		return FirstValue-CalculateNextExpectedChange(SubSequence)

Total = 0
for line in Input.split("\n"):
	if line == "":
		continue
	Sequence = line.split(" ")
	Total = Total + CalculateNextExpectedChange(Sequence)

print("Total:", Total)
