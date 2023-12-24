""" Post-Completion Explanation
Basic expansion iteration from a start point
Since we need everything valid on the final step, and since we only move in straight lines,
we know that if we have an even amount of iterations, every square reached on an even iteration will be in the final result,
and the same logic applies to odd
This means we can avoid wasting time iterating from already traversed spots and focus on just moving outwards
"""
Input = open("input.txt", "r").read()

Iterations = 64
TraversedSquares = set()
SquaresThatMeetCondition = set()
PointsOfExpansion = []
Lines = Input.split("\n")
GroundMap = []
for LineN in range(len(Lines)):
	line = Lines[LineN]
	if line == "":
		continue
	GroundMap.append(line)
	RowLength = len(line)
	if (SPoint := line.find("S")) > -1:
		PointsOfExpansion.append([SPoint, LineN])
ColumnLength = len(GroundMap)

for i in range(Iterations):
	for X, Y in list(PointsOfExpansion):
		for NewX, NewY in [[X-1, Y], [X+1, Y], [X, Y-1], [X, Y+1]]:
			Hash = f"{NewX}|{NewY}"
			if NewX >= 0 and NewY >= 0 and NewX < RowLength and NewY < ColumnLength:
				if Hash not in TraversedSquares and GroundMap[NewY][NewX] != "#":
					TraversedSquares.add(Hash)
					PointsOfExpansion.append([NewX, NewY])
					if i%2 == (Iterations-1)%2:
						SquaresThatMeetCondition.add(Hash)
print("Seen squares on final step:", len(SquaresThatMeetCondition))
