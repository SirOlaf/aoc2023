import std/[
  strutils,
  sequtils,
  tables,
  algorithm,
  sugar,
]


type
  HandType = enum
    # strongest
    fiveOfAKind
    fourOfAKind
    fullHouse
    threeOfAKind
    twoPair
    onePair
    highCard
    # weakest

  Hand = distinct string
  Card = distinct char

const validCards = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']


let input = readFile("input.txt").splitLines().filterIt(it.len() > 0).mapIt(it.split())
assert input.len() > 0 and input[0].len() == 2


proc classifyHand(x: Hand): HandType =
  var counts = toCountTable(x.string)
  let max = counts.largest().val
  case max
  of 5:
    fiveOfAKind
  of 4:
    fourOfAKind
  of 3:
    if counts.len() == 2:
      fullHouse
    else:
      threeOfAKind
  of 2:
    if counts.len() == 3:
      var twos = 0
      for x in counts.values():
        if x == 2:
          inc twos
      if twos == 2:
        twoPair
      else:
        onePair
    else:
      onePair
  of 1:
    highCard
  else:
    raiseAssert "Bad count"

proc toStr(x: CountTable[char]): string =
  for c in x.pairs():
    result &= repeat(c[0], c[1])

proc findCardIdx(self: Card): int =
  for i in 0 ..< validCards.len():
    if self.char == validCards[i]:
      return i
  raiseAssert "bad card"

proc bruteforceStrongestHandType(x: Hand): HandType =
  var unjokered = toCountTable(x.string)
  let jokerCount = unjokered['J']
  unjokered.del 'J'
  if jokerCount == 0:
    x.classifyHand()
  else:
    let unjokeredStr = unjokered.toStr()
    var wilds = newSeqWith[char](jokerCount, validCards[0])
    var bestRank = classifyHand(Hand(unjokeredStr & cast[string](wilds)))

    while true:
      var done = false
      var j = 0
      while wilds[j].Card.findCardIdx() == validCards.len() - 1:
        inc j
        if j == jokerCount:
          done = true
          break
      if done:
        break

      wilds[j] = validCards[wilds[j].Card.findCardIdx() + 1]
      for k in 0 ..< j:
        wilds[k] = 'A'
      let rank = classifyHand(Hand(unjokeredStr & cast[string](wilds)))
      if rank < bestRank:
        bestRank = rank
    bestRank


proc cmp(self, other: Card): int =
  self.findCardIdx().cmp(other.findCardIdx())


proc cmp(self, other: Hand): int =
  assert self.string.len() == 5 and other.string.len() == 5
  let
    selfRank = self.bruteforceStrongestHandType()
    otherRank = other.bruteforceStrongestHandType()

  if selfRank < otherRank:
    -1
  elif selfRank == otherRank:
    for i in 0 ..< self.string.len():
      let r = self.string[i].Card.cmp(other.string[i].Card)
      if r != 0:
        return r
    0
  else:
    1


let sortedGames = input.sorted(order=Descending, cmp = (x, y) => x[0].Hand.cmp(y[0].Hand))

var accum = 0
for i in 0 ..< sortedGames.len():
  accum += sortedGames[i][1].parseInt() * (i + 1)
echo accum