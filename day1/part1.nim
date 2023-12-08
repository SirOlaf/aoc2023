import std/[
  strutils,
  sequtils,
]


let lines = cast[string](readFile("input.txt").filterIt(it in {'0'..'9', '\n'})).splitLines()


var accum = 0
for line in lines:
  if line.len() > 0:
    let val = parseInt($line[0] & $line[^1])
    accum += val
echo accum
