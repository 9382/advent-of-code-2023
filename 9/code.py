Input = open("input.txt", "r").read()

def CalculateNextExpectedChange(Sequence):
	LastValue = int(Sequence[len(Sequence)-1])
	SubSequence = []
	IsAllZero = True
	for i in range(len(Sequence)-1):
		NextValue = int(Sequence[i+1]) - int(Sequence[i])
		if NextValue != 0:
			IsAllZero = False
		SubSequence.append(NextValue)
	if IsAllZero: # The sequence has no changes (our rate of change is consistent), send up the consistent change
		return LastValue
	else: # The sequence has a predicted rate of change of whatever the subsequence resolves to, so adjust our last value by that amount
		return LastValue+CalculateNextExpectedChange(SubSequence)

Total = 0
for line in Input.split("\n"):
	if line == "":
		continue
	Sequence = line.split(" ")
	Total = Total + CalculateNextExpectedChange(Sequence)

print("Total:", Total)
