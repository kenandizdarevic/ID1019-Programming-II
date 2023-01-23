defmodule EnvList do

  def test do
    list = [{:a, 1}, {:b, 2}, {:c, 3}, {:d, 4}, {:e, 5}]
    remove(list, :a)
  end

  # Create empty list
  def new() do [] end

  # ----- CASES -----
  # 1. Empty map
  # 2. Same key in map as the one that is added
  # 3. Add new key
  def add([], key, value) do [{key, value}] end
  def add([{key, _} | tail], key, value) do [{key, value} | tail] end
  def add([head | tail], key, value) do [head | add(tail, key, value)] end

  # ----- CASES -----
  # 1. Empty map
  # 2. Key not in map
  # 3. Key in map
  def lookup([], _) do nil end
  def lookup([{key, value} | _], key) do {key, value} end
  def lookup([_ | tail], key) do lookup(tail, key) end

  # ----- CASES -----
  # 1. Empty map
  # 2. Key not in map
  # 3. Key in map
  def remove([], _) do [] end
  def remove([{key, value} | tail], key) do tail end
  def remove([head | tail], key) do [head | remove(tail ,key)] end

end
