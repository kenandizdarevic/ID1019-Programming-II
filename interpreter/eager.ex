defmodule Eager do

  def eval_expr({:atom, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} ->
        {:ok, str}
    end
  end
  def eval_expr({:cons, ..., ...}, ...) do
    case eval_expr(..., ...) do
      :error ->
        :error
      {:ok, ...} ->
        case eval_expr(..., ...) do
          :error ->
            ...
          {:ok, ts} ->
            ...
        end
    end
  end
end
