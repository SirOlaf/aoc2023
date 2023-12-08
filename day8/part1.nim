import std/[
  strutils,
  tables,
  strscans,
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


var accum = 0
var nodeName = "AAA"
var instrIdx = 0
while nodeName != "ZZZ":
  let instr = instructions[instrIdx]
  if instr == 'L':
    nodeName = map[nodeName].left
  else:
    nodeName = map[nodeName].right

  inc instrIdx
  if instrIdx == instructions.len():
    instrIdx = 0
  
  inc accum
echo accum