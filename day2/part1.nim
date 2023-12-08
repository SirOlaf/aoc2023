import std/[
  strutils,
  sequtils,
]


type
  Color = enum
    red, green, blue

const allowedNums: array[Color, int] = [red : 12, green : 13, blue: 14]


let games = readFile("input.txt")
  .splitLines()
  .filterIt(it.len() > 0)
  .mapIt(it.split(":")[1])
  .mapIt(it.split(";"))


proc checkSet(cubeSet: string): bool =
  for draw in cubeSet.split(",").mapIt(it.strip().split()):
    let
      num = parseInt(draw[0])
      color = parseEnum[Color](draw[1])
    if allowedNums[color] < num:
      return false
  true

proc checkGame(game: seq[string]): bool =
  for cubeSet in game:
    if not checkSet(cubeSet):
      return false
  true

var accum = 0
for i in 0 ..< games.len():
  if checkGame(games[i]):
    accum += i + 1
echo accum
