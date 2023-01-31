defmodule Env do
  def new() do [] end

  def add(id, str, []) do [{id, str}] end

  def lookup(id, []) do nil end
  def lookup(id, env)

  def remove(id, []) do [] end
end
