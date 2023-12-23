""" Post-Completion Explanation
First of all, we split each of our cards into its 7 primary groups listed below.
We figure out which group a card lies in using as little data as we can
(said data being which groups it already failed to meet, how many unique cards there are, and their frequencies)

Next, we sort each individual group by giving a card a numerical value based on its characters and then using python's .sort() method
From here, we add up all the values, and thats us done
"""
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

CardByType = {1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[]}
for line in Input.split("\n"):
	if line == "":
		continue
	Cards, Bid = line.split(" ")
	Bid = int(Bid)
	CardFrequencies = {}
	for Card in Cards:
		if Card in CardFrequencies:
			CardFrequencies[Card] += 1
		else:
			CardFrequencies[Card] = 1
	Frequencies = CardFrequencies.values()
	if len(CardFrequencies) == 1: # Rank 7
		CardByType[7].append([Cards, Bid])
	elif len(CardFrequencies) == 2 and 4 in Frequencies: # Rank 6
		CardByType[6].append([Cards, Bid])
	elif len(CardFrequencies) == 2 and 3 in Frequencies and 2 in Frequencies: # Rank 5
		CardByType[5].append([Cards, Bid])
	elif len(CardFrequencies) == 3 and 3 in Frequencies: # Rank 4
		CardByType[4].append([Cards, Bid])
	elif len(CardFrequencies) == 3 and 2 in Frequencies and 1 in Frequencies: # Rank 3
		CardByType[3].append([Cards, Bid])
	elif len(CardFrequencies) == 4 and 2 in Frequencies: # Rank 2
		CardByType[2].append([Cards, Bid])
	else: # Rank 1
		CardByType[1].append([Cards, Bid])

LabelToValue = {"A":14, "K":13, "Q":12, "J":11, "T":10}
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
