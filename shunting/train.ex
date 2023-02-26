defmodule Train do

  # Returns the train containing first n wagons
  def take(_, 0) do [] end
  def take([], _n) do [] end
  def take([head | tail], n) when n > 0 do [head | take(tail, n - 1)] end

  # Returns train without its first n wagons
  def drop([], _n) do [] end
  def drop(train, 0) do train end
  def drop([_head | tail], n) do drop(tail, n - 1) end

  # Combination of two trains
  def append(one, []) do one end
  def append([], two) do two end
  def append([head | tail], two) do [head | append(tail, two)] end

  # Check if wagon is in train
  def member([], _wagon) do false end
  def member([head | tail], wagon) do
    case head == wagon do
      true ->
        true
      _ ->
        member(tail, wagon)
    end
  end

  # Returns first posiont of wagon in train
  def position([head | tail], wagon) do
    case head == wagon do
      true ->
        1
      _ ->
        position(tail, wagon) + 1
    end
  end

  # Return tuple with two trains, wagon not in any of them
  def split(train, wagon) do
    {take(train, position(train, wagon) - 1), drop(train, position(train, wagon))}
  end

  # Return {k, remain, take} where remain & take are wagons of train
  def main([], n) do {n, [], []} end
  def main(train, 0) do {0, train, []} end
  def main([head | tail], n) do
    case main(tail, n) do
      {0, remain, take} ->
        {0, [head | remain], take}
      {k, remain, take} ->
        {k - 1, remain, [head | take]}
      end
  end

  # Possible to do with split/2
  def mainSplit(train, n) do
    {take, remain} = split(train, n)
    {n - length(take), remain, take}
  end
end
