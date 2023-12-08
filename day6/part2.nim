import std/[
  strutils,
  sequtils,
]


let
  input = readFile("input.txt").splitLines()
  recordTime = input[0].split(":")[1].split().mapIt(it.strip()).filterIt(it.len() > 0).join("").parseInt()
  recordDistance = input[1].split(":")[1].split().mapIt(it.strip()).filterIt(it.len() > 0).join("").parseInt()


proc findWinningHolds(recordTime: int, recordDistance: int): int =
  for i in 1 ..< recordTime - 1:
    let
      speed = i
      remainingTime = recordTime - i
      dist = speed * remainingTime
    if dist > recordDistance:
      inc result

echo findWinningHolds(recordTime, recordDistance)
