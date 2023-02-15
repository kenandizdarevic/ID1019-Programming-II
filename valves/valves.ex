defmodule Valves do

  def task() do
    start = :AA
    #rows = File.stream!("input.csv")
    rows = sample()
    map = parse(rows)
    time = 30
    closed = []
    opened = []

    {max_rate, max_path} = search(start, time, closed, opened, 0, map, [])

    IO.puts("Maximum rate: #{max_rate}")
    IO.inspect(max_path)
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

  # ---------- ARGUMENTS ----------
  # valve: current valve being considered
  # time: time left
  # closed: valves which are currently closed
  # opened: valves which are currently open
  # rate: current rate of flow
  # map:
  # path: current path being taken


  # No time left
  def search(_, 0, _, _, _, _, path) do {0, path} end
  # All valves are opened
  def search(_, time, [], _, rate, _, path) do
    {rate * time, path}
  end

  def search(valve, time, closed, opened, rate, map, path) do
    {valveRate, tunnels} = Map.get(map, valve)

    {maxRate, maxPath} =
      case Enum.member?(closed, valve) do
        true ->
          [removed | remaining] = closed
          added = insert(opened, valve)
          {subMaxRate, subMaxPath} =
            search(removed, time - 1, remaining, added, rate + valveRate, map, [valve | path])
          {subMaxRate + rate, subMaxPath}
        false ->
          {rate * time, path}
      end

    {finalRate, finalPath} =
      Enum.reduce(tunnels, {maxRate, maxPath}, fn(nextValve, {maxRate, maxPath}) ->
        {subRate, subPath} =
          search(nextValve, time - 1, closed, opened,rate, map, path)
        subRate = subRate + rate
        if subRate > maxRate do
          {subRate, subPath}
        else
          {maxRate, maxPath}
        end
      end)

    {finalRate, finalPath}
  end

  def insert(list, element) do [element | list] end


end
