image = [[false, true, false], [false, false, true], [true, true, true]]

def draw(array)
    array.each do |row|
        row.each {|c| print c ? "#" : "." }
        puts ""
    end
end

def flip_h(source_array)
    array = source_array.clone
    if array.size == 2
        array.reverse!
    else
        first = array.shift
        second = array.shift
        array << second
        array << first
    end
    array
end

def flip_v(array)
    flip_h(array.transpose).transpose
end

def to_str(array)
    array.map{|r| r.map{|c| c ? "#" : "."}.join}.join('/')
end

def from_str(definition : String)
    definition.split('/').map do |row|
        row.split("").map {|c| c == "#" }
    end
end

def join(images)
    row_size = Math.sqrt(images.size).to_i
    result = [] of Array(Bool)
    images.each_slice(row_size) do |slice|
        slice.first.size.times do |i|
            result << slice.map{|r| r[i]}.flatten
        end
    end
    result
end

def divide(image)
    images = [] of Array(Array(Bool))
    size = image.first.size
    if size.even?
        image.each_slice(2) do |two_rows|
            (size/2).to_i.times do |param_base|
                param = param_base * 2
                images << [
                    [two_rows.first[0+param], two_rows.first[1+param]],
                    [two_rows.last[0+param], two_rows.last[1+param]]
                ]
            end
        end
    else
        image.each_slice(3) do |rows|
            (size/3).to_i.times do |param_base|
                param = param_base * 3
                images << [
                    [rows[0][0+param], rows[0][1+param], rows[0][2+param]],
                    [rows[1][0+param], rows[1][1+param], rows[1][2+param]],
                    [rows[2][0+param], rows[2][1+param], rows[2][2+param]]
                ]
            end
        end
    end
    images
end

def find_rule(image, rulebook)
    candidates = [
        to_str(image),
        to_str(flip_h(image)),
        to_str(flip_v(image)),
        to_str(image.transpose),
        to_str(flip_h(flip_v(image.transpose))),
        to_str(flip_h(flip_v(image.transpose)).transpose)
    ]
    matches = rulebook.select(candidates).first[1]
end

def count_on(image)
    image.flatten.select {|v| v}.size
end

input = File.read_lines("input").map{|line| line.split(" => ")}.to_h

18.times do |i|
    images = divide(image).map do |subimage|
        result = find_rule(subimage, input)
        from_str(result)
    end
    image = join(images)
    puts count_on(image) if i == 4
end

puts count_on(image)