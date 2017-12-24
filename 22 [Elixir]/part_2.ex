defmodule Universe do
    use Agent

    def start_link do
        Agent.start_link(fn -> Map.new end, name: __MODULE__)
    end

    def modify!(cell) do
        new_state = case get_state(cell) do
            :clean -> :weakened
            :weakened -> :infected
            :infected -> :flagged
            :flagged -> :clean
        end
        
        set_state!(cell, new_state)
        new_state
    end

    def set_state!(cell, state) do
        Agent.update(__MODULE__, &Map.put(&1, cell, state))
    end

    def get(cell) do
        Agent.get(__MODULE__, &Map.fetch(&1, cell))
    end

    def get_state(cell) do
        case get(cell) do
            :error -> :clean
            {:ok, state} -> state
        end
    end

    def all() do
        Agent.get(__MODULE__, &(&1))
    end
end

defmodule Direction do
   def turn(current, direction) do
        directions = [{0,1},{1,0},{0,-1},{-1,0}]
        idx = Enum.find_index(directions, fn(x) -> x == current end)
        new_idx = rem(idx + 4 + direction, 4)
        Enum.at(directions, new_idx)
   end

   def dir_offset(state) do
       case state do
           :clean -> -1
           :infected -> 1
           :weakened -> 0
           :flagged -> 2
       end
   end
end

defmodule BurstControl do
    def burst(_cell, _direction, infected, 10000000) do
        IO.puts(infected)
    end

    def burst(cell, direction, infected, bursts) do
        old_state = Universe.get_state(cell)
        new_state = Universe.modify!(cell)
        dir_offset = Direction.dir_offset(old_state)
        new_direction = Direction.turn(direction, dir_offset)
        has_infected = case new_state do
            :infected -> 1
            _ -> 0
        end
        
        x = elem(cell, 0) + elem(new_direction, 0)
        y = elem(cell, 1) + elem(new_direction, 1)
        new_cell = {x, y}
        burst(new_cell, new_direction, infected + has_infected, bursts + 1)
    end
end

Universe.start_link

File.stream!("input") 
|> Stream.map(&String.trim/1)
|> Stream.with_index
|> Stream.map(fn ({line, index}) -> 
    offset = round((String.length(line)-1)/2)
    y = (index - offset) * -1
    String.split(line, "", trim: true)
    |> Stream.with_index
    |> Enum.each(fn ({char, idx}) ->
        if char == "#" do
            Universe.set_state!({idx-offset, y}, :infected)
        end
    end)
 end)
|> Stream.run
BurstControl.burst({0,0},{0,1},0,0)
