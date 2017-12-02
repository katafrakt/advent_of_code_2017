function find_edv(numbers)
    for x in numbers
        for y in numbers
            result = x/y
            if result != 1 && isinteger(result)
                return result
            end
        end
    end
end

input = open("input")
sum = 0
for ln in eachline(input)
    numbers = map(x->parse(Int, x), split(ln))
    sum = sum + trunc(Int, find_edv(numbers))
end
println("$sum")