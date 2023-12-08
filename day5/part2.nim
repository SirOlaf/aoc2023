import std/[
  strutils,
  sequtils,
  sets,
  tables,
]


type
  Range = object
    a, b: int

  MappingInfo = object
    srcRange, destRange: Range
    #srcStart, destStart, size: int

  AToBMap = object
    nameA, nameB: string
    ranges: seq[MappingInfo]


proc contains(self: Range, x: int): bool =
  x >= self.a and x <= self.b

proc crackRange(self: AToBMap, rng: Range): seq[Range] =
  ## Cracks a range into several smaller pieces
  var splitRanges = @[rng]
  while splitRanges.len() > 0:
    let s = splitRanges.pop()

    var didSplit = false
    for r in self.ranges:
      let r = r.srcRange

      if r.contains(s.a) and r.contains(s.b):
        result.add(Range(a : s.a, b: s.b))
        didSplit = true
        break
      elif r.contains(s.a) and s.b > r.b:
        # overflow on high side
        result.add(Range(a : s.a, b : r.b)) # add contained portion to result
        assert result[^1].a < result[^1].b
        splitRanges.add(Range(a : r.b + 1, b : s.b)) # add fully excluded portion to splitRanges for next iteration
        assert splitRanges[^1].a < splitRanges[^1].b
        didSplit = true
        break
      elif r.contains(s.b) and s.a < r.a:
        # overflow on low side
        result.add(Range(a : r.a, b : s.b))
        assert result[^1].a < result[^1].b
        splitRanges.add(Range(a : s.a, b : r.a - 1))
        assert splitRanges[^1].a < splitRanges[^1].b
        didSplit = true
        break
      elif s.contains(r.a) and s.contains(r.b):
        # overflow on both sides
        result.add(r) # add contained range
        splitRanges.add(Range(a : s.a, b : r.a - 1))
        splitRanges.add(Range(a : r.b + 1, b : s.b))
        didSplit = true
        break

    if not didSplit:
      result.add(s) # preserve the full range


proc mapNum(self: AToBMap, x: int): int =
  for r in self.ranges:
    if r.srcRange.contains(x):
      let off = x - r.srcRange.a
      return r.destRange.a + off
  return x # remain unmapped when not in ranges

proc mapRange(self: AToBMap, r: Range): Range =
  ## Takes a range piece and maps it according to AToBMap
  let
    a = self.mapNum(r.a)
    b = self.mapNum(r.b)

  assert a < b, $a & "<" & $b & " --- " & $r.a & "<" & $r.b
  Range(
    a : a,
    b : b,
  )

proc followRange(self: Table[string, AToBMap], name: string, r: Range): int =
  result = high(int)
  if name notin self:
    return r.a
  let map = self[name]
  let crackedRange = map.crackRange(r)
  for c in crackedRange:
    let mapped = map.mapRange(c)
    let x = self.followRange(map.nameB, mapped)
    if x < result:
      result = x

var seedRanges = newSeq[Range]()
var aToBMaps = initTable[string, AToBMap]()

let input = readFile("input.txt").split("\n\n").mapIt(it.split(":"))
for segment in input:
  assert segment.len() == 2
  let segmentName = segment[0].strip()
  if segmentName == "seeds":
    let parts = segment[1].split().filterIt(it.len() > 0)
    for i in countup(0, parts.len() - 1, 2):
      let
        a = parts[i].parseInt()
        size = parts[i+1].parseInt()
      seedRanges.add(Range(a : a, b : a + size))
  else:
    # must be a map
    doAssert segmentName.endsWith("map")
    var mappings = newSeq[MappingInfo]()
    for line in segment[1].splitLines().filterIt(it.len() > 0):
      let parts = line.split()
      let
        srcStart = parts[1].parseInt()
        destStart = parts[0].parseInt()
        size = parts[2].parseInt()
      let info = MappingInfo(
        srcRange : Range(a : srcStart, b : srcStart + size),
        destRange : Range(a : destStart, b : destStart + size),
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
for seedRange in seedRanges:
  let x = aToBMaps.followRange("seed", seedRange)
  if x < lowest:
    lowest = x
echo lowest
