""" Post-Completion Explanation
We create a list of every possible term and the digit it equates to (0-9 -> 0-9 and the word versions as required)
We then .find() each term and store the lowest one for the first term
We do the same for the last term by flipping the input string (and the terms for the words) and using .find()
"""
InputData = open("input.txt", "r").read()
Total = 0
# it's a bit lazy and I think not efficient but we can just apply [::-1] to flip the strings for the "last one"
# Saves us time and this isn't too intense since its just like 15 characters per line
SearchTerms = {
	"one": 1, "two": 2, "three": 3, "four":4, "five": 5,
	"six": 6, "seven": 7, "eight":8, "nine":9,
}
for i in range(10):
	SearchTerms[str(i)] = i
for line in InputData.split("\n"):
	if line == "":
		continue
	FirstNum, LastNum = None, None
	FirstBest, LastBest = 9e9, 9e9
	for term, value in SearchTerms.items():
		position = line.find(term)
		if position > -1 and position < FirstBest:
			FirstNum, FirstBest = value, position
		position = line[::-1].find(term[::-1]) #magical double flipping that I don't like
		if position > -1 and position < LastBest:
			LastNum, LastBest = value, position
	Total = Total + int(str(FirstNum) + str(LastNum)) #int to str to int, woops
print("Total:", Total)
