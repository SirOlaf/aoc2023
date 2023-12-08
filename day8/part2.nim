import std/[
  strutils,
  sequtils,
  tables,
  strscans,
  math,
]


let input = readFile("input.txt").splitLines()
let instructions = input[0]

var map = initTable[string, tuple[left: string, right: string]]()
for i in 1 ..< input.len():
  let line = input[i]
  if line.len() == 0:
    continue

  var src, left, right: string
  if scanf(line, "$w = ($w, $w)", src, left, right):
    assert src notin map
    map[src] = (left, right)
  else:
    raiseAssert "malformed input"


proc findMinCycles(map: Table[string, tuple[left: string, right: string]], instructions: string, startingNode: string): int =
  var node = startingNode
  var instrIdx = 0
  while true:
    let instr = instructions[instrIdx]
    if instr == 'L':
      node = map[node].left
    else:
      node = map[node].right
    
    inc instrIdx
    if instrIdx == instructions.len():
      instrIdx = 0
      inc result
      if node.endsWith('Z'):
        break


var startingNodes = newSeq[string]()
for node in map.keys():
  if node.endsWith("A"):
    startingNodes.add(node)


var cycleCounts = startingNodes.mapIt(findMinCycles(map, instructions, it))
echo lcm(cycleCounts) * instructions.len() # luckily cycles are good enough
