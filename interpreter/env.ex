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

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error ->
          :error
        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]
            nil ->
              :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    List.zip([pars, args]) ++ env
  end
end
