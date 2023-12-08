import std/[
  strutils,
  sequtils,
  tables,
]


const
  numMap = {
    "one": '1',
    "two": '2',
    "three": '3',
    "four": '4',
    "five": '5',
    "six": '6',
    "seven": '7',
    "eight": '8',
    "nine": '9',
  }.toTable()
  usefulInputs = numMap.keys().toSeq() & numMap.values().toSeq().mapIt($it)
  longestPossible = block:
    let tmp = usefulInputs.mapIt(it.len())
    tmp[tmp.maxIndex()]


let lines = readFile("input.txt").splitLines()

var accum = 0
for line in lines:
  var digits = newSeq[char]()
  for i in 0 ..< line.len():
    let sub = line[i ..< min(line.len(), i + longestPossible)]
    for useful in usefulInputs:
      if sub.startsWith(useful):
        if useful in numMap:
          digits.add(numMap[useful])
        else:
          digits.add(sub[0])
  if digits.len() > 0:
    accum += parseInt(digits[0] & digits[^1])
echo accum
