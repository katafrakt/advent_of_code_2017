defmodule Universe do
    use Agent

    def start_link do
        Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
    end

    def infect(cell) do
        Agent.update(__MODULE__, &MapSet.put(&1, cell))
    end

    def heal(cell) do
        Agent.update(__MODULE__, &MapSet.delete(&1, cell))
    end

    def infected?(cell) do
        Agent.get(__MODULE__, &MapSet.member?(&1, cell))
    end

    def get() do
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
end

defmodule BurstControl do
    def burst(_cell, _direction, infected, 10000) do
        IO.puts(infected)
    end

    def burst(cell, direction, infected, bursts) do
        {new_direction, has_infected} = if Universe.infected?(cell) do
            Universe.heal(cell)
            {Direction.turn(direction, 1), 0}
        else
            Universe.infect(cell)
            {Direction.turn(direction, -1), 1}
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
            Universe.infect({idx-offset, y})
        end
    end)
 end)
|> Stream.run
BurstControl.burst({0,0},{0,1},0,0)
