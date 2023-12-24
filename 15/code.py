""" Post-Completion Explanation
Very little to mention here, it's just applying maths to character ASCII values
We can get away with doing the modulus at the end of the calculation instead of at each character;
we only ever add numbers to value and don't use it, so the output is the same regardless of when it happens
"""
Input = open("input.txt", "r").read()

def PerformHashing(string):
	value = 0
	for char in string:
		value = ((value + ord(char)) * 17)
	return value % 256

Total = 0
for string in Input.replace("\n", "").split(","):
	if string == "":
		continue
	Total = Total + PerformHashing(string)

print("Total:", Total)
