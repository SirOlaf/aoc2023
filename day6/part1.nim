import std/[
  strutils,
  sequtils,
]


let
  input = readFile("input.txt").splitLines()
  times = input[0].split(":")[1].split().mapIt(it.strip()).filterIt(it.len() > 0)
  distances = input[1].split(":")[1].split().mapIt(it.strip()).filterIt(it.len() > 0)
assert times.len() == distances.len()


proc findWinningHolds(recordTime: int, recordDistance: int): int =
  for i in 1 ..< recordTime - 1:
    let
      speed = i
      remainingTime = recordTime - i
      dist = speed * remainingTime
    if dist > recordDistance:
      inc result


var accum = 1
for i in 0 ..< times.len():
  accum *= findWinningHolds(times[i].parseInt(), distances[i].parseInt())
echo accum

