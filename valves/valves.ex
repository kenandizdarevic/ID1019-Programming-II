defmodule Valves do

  def task() do
    start = :AA
    #rows = File.stream!("day16.csv")
    rows = sample()
    parse(rows)

   # IO.puts("Maximum rate: #{max_rate}")
   # IO.inspect(max_path)
  end

  ## turning rows
  ##
  ##  "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE"
  ##
  ## into tuples
  ##
  ##  {:DD, {20, [:CC, :AA, :EE]}
  ##

  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end

  # No time left
  def memory(_valve, 0, _closed, _open, _rate, _map, path, cache) do
    {0, path, cache}
  end
  # All valves are open
  def memory(valve, time, [], open, rate, _map, path, cache) do
    total = rate * time
    cache = Memory.store({valve, time, open}, {total, path}, cache)
    {total, path, cache}
  end

  def memory(valve, time, closed, open, rate, map, path, cache) do
    case Memory.lookup({valve, time, open}, cache) do
      nil ->
        # No previous solution found, search for new!
        {max, path, cache} = search(valve, time, closed, open, rate, map, path, cache)
        mem = Memory.store({valve, time, open}, {max, path}, cache)
        {max, path, cache}
      {max, path} ->
        # Solution found, return it!
        {max, path, cache}
    end
  end


end
