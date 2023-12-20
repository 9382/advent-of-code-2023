Input = open("input.txt", "r").read()

class Range:
	def __init__(self, StartValue, Length):
		assert Length>=1
		self.StartValue = StartValue
		self.Length = Length
	def Min(self):
		return self.StartValue
	def Max(self):
		return self.StartValue+self.Length-1
	def Contains(self, n):
		return (n >= self.StartValue and n < self.StartValue+self.Length)
	def Clone(self):
		return Range(self.StartValue, self.Length)

class PartObj:
	def __init__(self, x, m, a, s):
		self.x = x
		self.m = m
		self.a = a
		self.s = s
	def GetValue(self):
		return self.x.Length*self.m.Length*self.a.Length*self.s.Length
	def Clone(self):
		Out = PartObj(None, None, None, None)
		Out.x = self.x.Clone()
		Out.m = self.m.Clone()
		Out.a = self.a.Clone()
		Out.s = self.s.Clone()
		return Out

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
	def WouldSplit(self, Part):
		if not self.HasCondition:
			return False, None, None
		TargetVar = getattr(Part, self.TestVariable)
		if TargetVar.Contains(self.TestValue):
			if self.TestValue == TargetVar.Min() and self.TestChar == "<":
				return False, None, None
			elif self.TestValue == TargetVar.Max() and self.TestChar == ">":
				return False, None, None
			Part1, Part2 = Part, Part.Clone()
			RangeCutoff = TargetVar.Max()-self.TestValue
			if self.TestChar == "<":
				RangeCutoff += 1 #I have no idea why this is needed, something upstream bad or something? idk but it works now so whatever
			Var1, Var2 = getattr(Part1, self.TestVariable), getattr(Part2, self.TestVariable)
			Var1.Length -= RangeCutoff
			Var2.Length = RangeCutoff
			Var2.StartValue += Var1.Length
			if self.TestChar == "<":
				return True, Part1, Part2
			else:
				return True, Part2, Part1
		else:
			return False, None, None
	def WouldFullyMatch(self, Part):
		if not self.HasCondition:
			return True
		f = (lambda v: v.Min() > self.TestValue) if self.TestChar == ">" else (lambda v: v.Max() < self.TestValue)
		return f(getattr(Part, self.TestVariable))

Conditions = {}
class ConditionObj:
	def __init__(self, string):
		self.Rules = [Rule(x) for x in string.split(",")]
	def GetSplitParts(self, Part):
		PartsToTest = [Part]
		PartToDestination = {}
		for Rule in self.Rules:
			for Part in list(PartsToTest):
				WouldSplit, ToSendOff, ToTest = Rule.WouldSplit(Part)
				if WouldSplit:
					PartsToTest.remove(Part)
					PartsToTest.append(ToTest)
					PartToDestination[ToSendOff] = Rule.Output
				elif Rule.WouldFullyMatch(Part):
					PartsToTest.remove(Part)
					PartToDestination[Part] = Rule.Output
				# else: wouldn't match at all, leave it in for testing
		return PartToDestination

def DoMainTest():
	StartingObject = PartObj(Range(1, 4000), Range(1, 4000), Range(1, 4000), Range(1, 4000))
	PartToCondition = {StartingObject: "in"}
	Total = 0
	print("Calculating all possibilities...")
	while len(PartToCondition) > 0:
		for Part, Condition in dict(PartToCondition).items():
			PartToCondition.pop(Part)
			NewParts = Conditions[Condition].GetSplitParts(Part)
			for Part, Condition in NewParts.items():
				if Condition in ["A", "R"]:
					if Condition == "A":
						Total = Total + Part.GetValue()
				else:
					PartToCondition[Part] = Condition
	print("Total accepted parts:", Total)

for line in Input.split("\n"):
	if line == "":
		DoMainTest()
		break
	SplitPoint = line.find("{")
	Conditions[line[:SplitPoint]] = ConditionObj(line[SplitPoint+1:-1])
