defmodule Moves do

  # Move is a binary tuple
  # First element is :one or :two
  # Second element is an integer
  # {:one, 2} or {:two, 1}

  # Decide by pattern-matching which track is involved
  # For a track decide wheter wagons are moved on or from (n + or -)
  # Use main/2 when moving wagons from main track

  def single({_, 0}, {main, one, two}) do {main, one, two} end
  # Move n wagons to track one
  def single({:one, n}, {main, one, two}) when n > 0 do
    {0, remain, take} = Train.main(main, n)
    {remain, Train.append(take, one), two}
    # {take, remain} = Train.split(main, length(main) - n)
    # {take, Train.append(remain, one), two}
  end
  def single({:one, n}, {main, one, two}) when n < 0 do
    n = abs(n)
    {Train.append(main, Train.take(one, n)), Train.drop(one, n), two}
  end
  def single({:two, n}, {main, one, two}) when n > 0 do
    {0, remain, take} = Train.main(main, n)
    {remain, one, Train.append(take, two)}
  end
  def single({:two, n}, {main, one, two}) when n < 0 do
    n = abs(n)
    {Train.append(main, Train.take(two, n)), one, Train.drop(two, n)}
  end

  def sequence([], state) do [state] end
  def sequence([head | tail], state) do
    [state | sequence(tail, single(head, state))]
  end

end
