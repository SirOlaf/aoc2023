import std/[
  strutils,
  sequtils,
  sets,
  math,
]


let input = readFile("input.txt").strip()
  .splitLines()
  .mapIt(
    it.split(":")[1]
  )
  .mapIt(it.split("|"))
  .mapIt(
    (
      it[0].split().filterIt(it.len() > 0).toHashSet(),
      it[1].split().filterIt(it.len() > 0).toHashSet()
      )
  )

var accum = 0
for line in input:
  let inter = line[0].intersection(line[1])
  accum += pow(2.float, (inter.len() - 1).float).int
echo accum