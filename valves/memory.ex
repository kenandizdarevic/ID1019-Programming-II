defmodule Memory do
  def new() do %{} end

  def store(key, value, memory) do
    Map.put(memory, key, value)
  end

  def lookup(key, memory) do
    Map.get(memory, key)
  end

  def insert(valve, []) do [valve] end
  def insert(valve, [head | tail]) when head < valve do
    [head | insert(valve, tail)]
  end
  def insert(valve, open) do [valve | open] end
end
