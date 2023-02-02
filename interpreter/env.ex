defmodule Env do
  def new() do [] end

  def add(id, str, env) do [{id, str} | env] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, str} | tail]) do {id, str} end
  def lookup(id, [head | tail]) do lookup(id, tail) end

  def remove(_, nil) do [] end
  def remove(_, []) do [] end
  def remove([], env) do env end
  def remove([id|tail], env) do remove(id, remove(tail, env)) end
  def remove(id, [{id, _}|tail]) do tail end
  def remove(id, [head|tail]) do [head|remove(id, tail)] end

  def closure([], env) do env end
  # Add closure/2

  # Add args/3
end
