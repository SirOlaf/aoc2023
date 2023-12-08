import std/[
  strutils,
  macros,
  sequtils,
]


let input = readFile("input.txt").splitLines().filterIt(it.len() > 0)


proc `[]`(input: seq[string], x, y: int): char =
  input[y][x]

proc isSymbol(grid: seq[string], x, y: int): bool =
  result = false
  if y >= 0 and y < grid.len() and x >= 0 and x < grid[y].len():
    return grid[x, y] notin {'0'..'9', '.'}

proc checkSurroundings(grid: seq[string], x, y: int): bool =
  result = false
  for xOff in -1 .. 1:
    for yOff in -1 .. 1:
      if grid.isSymbol(x + xOff, y + yOff):
        return true


template commit =
  if numStr.len() > 0:
    if keep:
      let num = parseInt(numStr)
      accum += num
    numStr.setLen(0)
    keep = false


var accum = 0
for y in 0 ..< input.len():
  var
    numStr = ""
    keep = false

  for x in 0 ..< input[y].len():
    if input[x, y] in '0'..'9':
      numStr.add(input[x, y])
      if not keep:
        keep = input.checkSurroundings(x, y)
    else:
      commit()
  commit()
echo accum
