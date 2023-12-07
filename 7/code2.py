Input = open("input.txt", "r").read()
""" Hand types			Rank
5 of a kind				7
4 of a kind				6
Full house (3 and 2)	5
3 of a kind				4
2 pairs					3
1 pair					2
As good as you can get	1
"""

def FindOptimalRank(Cards):
	CardFrequencies = {}
	Jokers = 0
	for Card in Cards:
		if Card == "J":
			Jokers += 1
		elif Card in CardFrequencies:
			CardFrequencies[Card] += 1
		else:
			CardFrequencies[Card] = 1
	# Optimise the frequencies
	if len(CardFrequencies) == 1 or Jokers == 5: #Turns into 5 of a kind
		return 7
	elif len(CardFrequencies) == 2: #Two types of card
		# Try form a 4 of a kind, else fall back to making a full house
		for Card, Amount in CardFrequencies.items():
			if Amount == 4-Jokers:
				return 6
		return 5
	elif len(CardFrequencies) == 3:
		# Try form a 3 of a kind, else fall back to making a set of 2 pairs
		for Card, Amount in CardFrequencies.items():
			if Amount == 3-Jokers:
				return 4
		return 3
	elif len(CardFrequencies) == 4:
		for Card, Amount in CardFrequencies.items():
			if Amount == 2-Jokers:
				return 2
		return 1
	return 1

CardByType = {1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[]}
for line in Input.split("\n"):
	if line == "":
		continue
	Cards, Bid = line.split(" ")
	WouldBeRank = FindOptimalRank(Cards)
	CardByType[WouldBeRank].append([Cards, int(Bid)])

LabelToValue = {"A":13, "K":12, "Q":11, "T":10, "J":"01"}
def CreateValueFromCards(Card):
	Num = ""
	for char in Card:
		if char in LabelToValue:
			Num = Num + str(LabelToValue[char])
		else:
			Num = Num + "0" + char
	return int(Num)
for CardSet in CardByType.values():
	CardSet.sort(key=lambda v: CreateValueFromCards(v[0]))

FinalCardRanking = []
for i in range(1, 7+1): #python ranges are :)
	FinalCardRanking.extend(CardByType[i])

Total = 0
for i in range(len(FinalCardRanking)):
	Total = Total + (i+1) * FinalCardRanking[i][1]

print("Total:", Total)
