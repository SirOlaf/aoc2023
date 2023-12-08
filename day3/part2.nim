import std/[
  strutils,
  macros,
  sequtils,
  tables,
  sets,
]

{.experimental: "inferGenericTypes".}


let input = readFile("input.txt").splitLines().filterIt(it.len() > 0)


proc `[]`(input: seq[string], x, y: int): char =
  input[y][x]

proc isGear(grid: seq[string], x, y: int): bool =
  result = false
  if y >= 0 and y < grid.len() and x >= 0 and x < grid[y].len():
    return grid[x, y] in {'*'}

proc findGears(grid: seq[string], x, y: int): HashSet[(int, int)] =
  result = initHashSet()
  for xOff in -1 .. 1:
    for yOff in -1 .. 1:
      if grid.isGear(x + xOff, y + yOff):
        result.incl((x + xOff, y + yOff))


template commit =
  for gear in nearbyGears:
    let num = parseInt(numStr)
    gears.mgetOrPut(gear, @[]).add(num)
  nearbyGears.clear()
  numStr.setLen(0)


var gears: Table[(int, int), seq[int]] = initTable()


for y in 0 ..< input.len():
  var
    numStr = ""
    nearbyGears: HashSet[(int, int)] = initHashSet()

  for x in 0 ..< input[y].len():
    if input[x, y] in '0'..'9':
      numStr.add(input[x, y])
      nearbyGears.incl(input.findGears(x, y))
    else:
      commit()
  commit()

var accum = 0
for gearPos, gearNums in gears:
  if gearNums.len() != 2:
    continue
  accum += gearNums[0] * gearNums[1]
echo accum
