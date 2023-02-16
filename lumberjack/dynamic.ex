defmodule Dynamic do

  # sequence [1, 1, 2, 2, 3]

  def search(seq) do elem(search(seq, Map.new()), 0) end

  def check(seq, mem) do
    case Map.get(mem, seq) do
      nil ->
        {cost, mem} = search(seq, mem)
        {cost, Map.put(mem, seq, cost)}
      cost ->
        {cost, mem}
    end
  end

  def search([], mem) do {0, mem} end
  def search([_], mem) do {0, mem} end
  def search(seq, mem) do
    # [{[1], [2], 3}, {[2], [1], 3}]
    Enum.reduce(split(seq), {:tomat, mem}, fn({left, right, length}, {acc, mem}) ->
      {cost_left, mem} = check(left, mem)
      {cost_right, mem} = search(right, mem)
      cost = cost_left + cost_right + length
      {min(acc, cost), mem}
    end)
  end

  def split([x | seq]) do split(seq, x, [x], [], []) end

  def split([], length, left, right, acc) do [{Enum.reverse(left), Enum.reverse(right), length} | acc] end
  def split([x], length, [], right, acc) do [{[x], Enum.reverse(right), length + x} | acc] end
  def split([x], length, left, [], acc) do [{Enum.reverse(left), [x], length + x} | acc] end
  def split([x | seq], length, left, right, acc) do
    split(seq, length + x, [x | left], right, split(seq, length + x, left, [x | right], acc))
  end
end
