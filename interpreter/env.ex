defmodule Env do
  def new() do [] end

  def add(id, str, env) do [{id, str} | env] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, str} | tail]) do {id, str} end
  def lookup(id, [head | tail]) do lookup(id, tail) end

  def remove(id, []) do [] end

end
