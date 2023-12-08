import std/[
  strutils,
  sequtils,
]


type
  Color = enum
    red, green, blue


let games = readFile("input.txt")
  .splitLines()
  .filterIt(it.len() > 0)
  .mapIt(it.split(":")[1])
  .mapIt(it.split(";"))


proc gamePower(game: seq[string]): int =
  var minNums: array[Color, int] = [red : 0, green : 0, blue: 0]
  for cubeSet in game:
    for draw in cubeSet.split(",").mapIt(it.strip().split()):
      let
        num = parseInt(draw[0])
        color = parseEnum[Color](draw[1])
      if num > minNums[color]:
        minNums[color] = num
  minNums.toSeq().foldl(a * b)

var accum = 0
for i in 0 ..< games.len():
  let pow = gamePower(games[i])
  accum += gamePower(games[i])
echo accum
