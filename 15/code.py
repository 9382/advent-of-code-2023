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
