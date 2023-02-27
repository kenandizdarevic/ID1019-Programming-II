defmodule Shunt do

  def test do
    train = [:a, :b, :c, :d]
    desired = [:c, :b, :d, :a]
    compress(few(train, desired))
  end

  def find([], _) do [] end
  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    [
      {:one, length(ts) + 1},
      {:two, length(hs)},
      {:one, -(length(ts) + 1)},
      {:two, -length(hs)} |
      find(Train.append(hs, ts), ys)
    ]
  end

  def few([], _) do [] end
  def few([h | hs], [y | ys]) when h == y do
    few(hs, ys)
  end
  def few(hs, [y | ys]) do
    {hs, ts} = Train.split(hs, y)

    [
      {:one, length(ts) + 1},
      {:two, length(hs)},
      {:one, -(length(ts) + 1)},
      {:two, -length(hs)} |
      few(Train.append(hs, ts), ys)
    ]
  end

  def rules([]) do [] end
  def rules([{_, 0} | tail]) do rules(tail) end
  def rules([{:one, n}, {:one, m} | tail]) do rules([{:one, n + m} | tail]) end
  def rules([{:two, n}, {:two, m} | tail]) do rules([{:two, n + m} | tail]) end
  def rules([head | tail]) do [head | rules(tail)] end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end
end
