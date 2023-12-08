import std/[
  strutils,
  sequtils,
  sets,
  math,
  tables,
]

{.experimental: "inferGenericTypes".}


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

var cardCounts: CountTable[int] = initCountTable()

for i in 0 ..< input.len():
  cardCounts.inc(i)
  let inter = input[i][0].intersection(input[i][1])
  for j in 0 ..< inter.len():
    cardCounts.inc(i+j+1, cardCounts[i])

var accum = 0
for val in cardCounts.values():
  accum += val
echo accum
