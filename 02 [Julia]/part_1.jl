input = open("input")
sum = 0
for ln in eachline(input)
    numbers = map(x->parse(Int, x), split(ln))
    max = maximum(numbers)
    min = minimum(numbers)
    diff = abs(max - min)
    sum = sum + diff
end
println("$sum")