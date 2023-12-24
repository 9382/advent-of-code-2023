""" Post-Completion Explanation
A case where I felt classes would probably be a good idea for code readability and just for practice
Take each input, run it through conditions until they become either accepted or rejected, and calculate the final result - not that complex
"""
Input = open("input.txt", "r").read()

import re

class PartObj:
	def __init__(self, string):
		x,m,a,s = re.search("x=(\d+),m=(\d+),a=(\d+),s=(\d+)", string).groups()
		self.x = int(x)
		self.m = int(m)
		self.a = int(a)
		self.s = int(s)
	def GetValue(self):
		return self.x+self.m+self.a+self.s #h

class Rule:
	def __init__(self, string):
		SplitPoint = max(string.find("<"), string.find(">"))
		if SplitPoint == -1:
			self.HasCondition = False
			self.Output = string
		else:
			self.HasCondition = True
			self.TestChar = string[SplitPoint]
			self.TestVariable = string[:SplitPoint]
			self.TestValue, self.Output = string[SplitPoint+1:].split(":")
			self.TestValue = int(self.TestValue) # :)
	def Test(self, Part):
		if not self.HasCondition:
			return True
		f = (lambda v: v > self.TestValue) if self.TestChar == ">" else (lambda v: v < self.TestValue)
		return f(getattr(Part, self.TestVariable))

Conditions = {}
class ConditionObj:
	def __init__(self, string):
		self.Rules = [Rule(x) for x in string.split(",")]
	def Test(self, Part):
		for Rule in self.Rules:
			if Rule.Test(Part):
				return Rule.Output

TestingParts = False
Total = 0
for line in Input.split("\n"):
	if line == "":
		TestingParts = True
		continue
	if TestingParts:
		Part = PartObj(line[1:-1])
		Result = "in"
		while Result not in ["A", "R"]:
			Result = Conditions[Result].Test(Part)
		if Result == "A":
			Total = Total + Part.GetValue()
	else:
		SplitPoint = line.find("{")
		Conditions[line[:SplitPoint]] = ConditionObj(line[SplitPoint+1:-1])

print("Total:", Total)
