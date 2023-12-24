""" Post-Completion Explanation
Uses the same hashing logic from part 1
Not much to explain here, the below comments explain mostly what's going on, it's just doing what the prompt wanted explicitly
"""
Input = open("input.txt", "r").read()

def PerformHashing(string):
	value = 0
	for char in string:
		value = ((value + ord(char)) * 17)
	return value % 256

# When removed by a -, we move FORWARDS as much as we can
# When adding an =, replacing old lenses if required. No lenses should be moved by an =
# If no lens is replaced by an =, the lens goes behind any lenses already in the box (or at the very front)
class Lens:
	def __init__(self, position, focal_length):
		self.position = position
		self.focal_length = focal_length

Boxes = []
for x in range(256):
	Boxes.append({})

for string in Input.replace("\n", "").split(","):
	if string == "":
		continue
	splitPoint = max(string.find("="), string.find("-"))
	labelName, labelOperation = string[:splitPoint], string[splitPoint:]
	TargetBox = Boxes[PerformHashing(labelName)]
	if labelOperation == "-":
		if labelName in TargetBox.keys():
			RemovedPosition = TargetBox.pop(labelName).position
			for label, lens in TargetBox.items():
				if lens.position > RemovedPosition:
					lens.position -= 1
	else:
		FocalLength = int(labelOperation[1])
		if labelName in TargetBox.keys():
			TargetBox[labelName].focal_length = FocalLength # lazy replacement
		else:
			TargetBox[labelName] = Lens(len(TargetBox)+1, FocalLength)

Total = 0
for i in range(len(Boxes)):
	Box = Boxes[i]
	for lens in Box.values():
		Total = Total + (i+1) * (lens.position) * (lens.focal_length)

print("Total:", Total)
