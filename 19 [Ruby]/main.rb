DIAGRAM = File.readlines('input').map{ |l| l.split('') }
EMPTY = ' '

Coords = Struct.new(:x, :y) do
    def +(coords)
        Coords.new(x + coords.x, y + coords.y)
    end

    def rev
        Coords.new(x * -1, y * -1)
    end
end

start_x = DIAGRAM[0].find_index { |i| i != EMPTY }
current_position = Coords.new(start_x, 0)
direction = Coords.new(0, 1)

def value_at(coords)
    DIAGRAM[coords.y][coords.x]
end

def find_next_position(current_position, direction)
    [Coords.new(0,1), Coords.new(0,-1), Coords.new(1, 0), Coords.new(-1, 0)].detect do |candidate|
        candidate != direction.rev && value_at(current_position + candidate) != EMPTY
    end
end

def out_of_bounds?(coords)
    coords.x < 0 || coords.y < 0 || coords.x >= DIAGRAM.first.length || coords.y >= DIAGRAM.length
end

letters = []
steps = 1

loop do
    following = current_position + direction
    if value_at(following) != EMPTY
        next_position = following
    else
        direction = find_next_position(current_position, direction)
        break if direction.nil?
        next_position = current_position + direction
    end

    break if out_of_bounds?(next_position)

    current_position = next_position
    if value_at(current_position) =~ /[A-Z]/
        letters << value_at(current_position)
    end
    steps += 1
end

puts letters.join
puts steps