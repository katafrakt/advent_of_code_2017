import strutils, sequtils

type bridgePart = tuple[low: int, high: int]

var line: string
var f = open("input")
var parts: seq[bridgePart] = @[]

while f.readLine(line):
    var ends = split(line, "/")
    var part: bridgePart
    var first = parseInt(ends[0])
    var second = parseInt(ends[1])

    if first > second:
        part = (low: second, high: first)
    else:
        part = (low: first, high: second)

    parts.add(part)

var partsStartingWithZero = filter(parts, proc(p: bridgePart): bool = p.low == 0)

proc reverse(part: bridgePart): bridgePart =
    result = (low: part.high, high: part.low)
    
proc calcStrength(bridge: seq[bridgePart]): int =
    result = 0
    for part in bridge:
        result += part.high
        result += part.low

proc buildBridge(bridge: seq[bridgePart], remaining: seq[bridgePart]): int =
    result = 0
    var last = bridge[bridge.len-1].high
    var matchingParts = filter(remaining, proc(x: bridgePart): bool = (x.low == last or x.high == last))
    if matchingParts.len == 0:
        return calcStrength(bridge)
    
    for part in matchingParts:
        var newBridge = bridge
        var newRemaining = remaining
        var idx = find(remaining, part)
        newRemaining.delete(idx, idx)
        if part.low == last:
            newBridge.add(part)
        else:
            newBridge.add(reverse(part))
        
        var res = buildBridge(newBridge, newRemaining)
        if res > result:
            result = res
            

var maxStrength = 0
for beginning in partsStartingWithZero:
    var remainingParts = parts
    var idx = find(parts, beginning)
    remainingParts.delete(idx,idx)
    var bridge = @[beginning]
    var result = buildBridge(bridge, remainingParts)
    if result > maxStrength:
        maxStrength = result

echo maxStrength
        