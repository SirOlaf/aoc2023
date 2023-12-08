import std/[
  strutils,
  sequtils,
  sets,
  tables,
]


type
  MappingInfo = object
    srcStart, destStart, size: int

  AToBMap = object
    nameA, nameB: string
    ranges: seq[MappingInfo]


proc mapNum(self: AToBMap, a: int): int =
  for r in self.ranges:
    if a >= r.srcStart and a <= r.srcStart + r.size:
      let off = a - r.srcStart
      return r.destStart + off
  return a # remain unmapped when not in ranges


var seeds = initHashSet[int]()
var aToBMaps = initTable[string, AToBMap]()

let input = readFile("input.txt").split("\n\n").mapIt(it.split(":"))
for segment in input:
  assert segment.len() == 2
  let segmentName = segment[0].strip()
  if segmentName == "seeds":
    seeds.incl(segment[1].split().filterIt(it.len() > 0).mapIt(it.parseInt()).toHashSet())
  else:
    # must be a map
    doAssert segmentName.endsWith("map")
    var mappings = newSeq[MappingInfo]()
    for line in segment[1].splitLines().filterIt(it.len() > 0):
      let parts = line.split()
      let info = MappingInfo(
        srcStart : parts[1].parseInt(),
        destStart : parts[0].parseInt(),
        size : parts[2].parseInt(),
      )
      mappings.add(info)
    let names = segmentName.split()[0].split("-")
    doAssert names[0] notin aToBMaps
    aToBMaps[names[0]] = AToBMap(
      nameA : names[0],
      nameB : names[2],
      ranges : mappings
    )


var lowest = high(int)
for seed in seeds:
  var map = aToBMaps["seed"]
  var v = seed
  while map.nameB in aToBMaps:
    v = map.mapNum(v)
    map = aToBMaps[map.nameB]
  v = map.mapNum(v)
  if v < lowest:
    lowest = v
echo lowest
