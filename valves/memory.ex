defmodule Memory do
  def new() do %{} end

  def store(key, value, memory) do
    Map.put(memory, key, value)
  end

  def lookup(key, memory) do
    Map.get(memory, key)
  end
end
