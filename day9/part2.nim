import std/[
  strutils,
  sequtils,
]


let input = readFile("input.txt").splitLines().filterIt(it.len() > 0).mapIt(it.strip().split().mapIt(it.parseInt()))

var accum = 0
for line in input:
  var progressions = @[line]
  while true:
    var newProgression = newSeq[int]()
    var allZero = true
    for i in 0 ..< progressions[^1].len() - 1:
      let
        a = progressions[^1][i]
        b = progressions[^1][i + 1]
        c = b - a
      if c != 0:
        allZero = false
      newProgression.add(c)
    progressions.add(newProgression)
    if allZero:
      break
  # slow solution, just prepend
  progressions[^1] = @[0] & progressions[^1]
  for i in countdown(progressions.len() - 2, 0):
    let
      a = progressions[i][0]
      b = progressions[i + 1][0]
      c = a - b
    progressions[i] = @[c] & progressions[i]
  accum += progressions[0][0]
echo accum
