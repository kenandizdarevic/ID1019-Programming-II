defmodule Valves do

  def task(time) do
    start = :AA

    closed = Enum.map(map, fn({valve, _}) -> valve end)
    {max, _, path} = memory(start, time, closed, [], 0, map, [], Memory.new())
    {max, Enum.reverse(path)}
    IO.puts("Maximum rate: #{max}")
  end

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

  # No time left
  def memory(_valve, 0, _closed, _open, _rate, _map, path, cache) do
    {0, path, cache}
  end
  # All valves are open
  def memory(valve, time, [], open, rate, _map, path, cache) do
    total = time * rate
    cache = Memory.store({valve, time, open}, {total, path}, cache)
    {total, path, cache}
  end
  # Check if we have searched the path before
  def memory(valve, time, closed, open, rate, map, path, cache) do
    case Memory.lookup({valve, time, open}, cache) do
      nil ->
        # No previous solution found, search for new & save it!
        {max, path, cache} = search(valve, time, closed, open, rate, map, path, cache)
        cache = Memory.store({valve, time, open}, {max, path}, cache)
        {max, path, cache}
      {max, path} ->
        # Solution found, return it!
        {max, path, cache}
    end
  end

  def search(valve, time, closed, open, rate, map, path, cache) do
    {currentRate, tunnels} = map[valve]
    {currentMax, currentPath, currentCache} = if Enum.member?(closed, valve) do
      # Valve is closed, open it
      removed = List.delete(closed, valve)
      {currentMax, currentPath, currentCache} = memory(valve, time - 1, removed, Memory.insert(valve, open), rate + currentRate, map, [valve | path], cache)
      currentMax = currentMax + rate
      {currentMax, currentPath, currentCache}
    else
      # Valve is alreday open, stay and wait
      {rate * time, path, cache}
    end

    Enum.reduce(tunnels, {currentMax, currentPath, cache},
      fn({next, distance}, {currentMax, currentPath, cache}) ->
        case distance < time do
          true ->
          # Move to next valve
            {newMax, newPath, cache} = memory(next, time - distance, closed, open, rate, map, path, cache)
            newMax = newMax + (rate * distance)
            case newMax > currentMax do
              true ->
                {newMax, newPath, cache}
              false ->
                {currentMax, currentPath, cache}
            end
          false ->
            {currentMax, currentPath, cache}
        end
      end
    )
  end
end
