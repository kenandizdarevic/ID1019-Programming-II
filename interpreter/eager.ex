defmodule Eager do

  def eval(seq) do eval_seq(seq, []) end

  def test do
    seq = [{:match, {:var, :x}, {:atom, :a}},
            {:case, {:var, :x},
              [{:clause, {:atom, :b}, [{:atom, :ops}]},
                {:clause, {:atom, :a}, [{:atom, :yes}]}
                  ]}]
    eval(seq)
  end

  def eval_expr({:atom, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
         {:ok, str}
    end
  end

  # Evaluation of a compound structure
  def eval_expr({:cons, headExpr, tailExpr}, env) do
    case eval_expr(headExpr, env) do
      :error ->
        :error
      {:ok, headStr} ->
        case eval_expr(tailExpr, env) do
          :error ->
            :error
          {:ok, tailStr} ->
            {:ok, {headStr, tailStr}}
        end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->{:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
            {:ok, strs} ->
              env = Env.args(par, strs, closure)
              eval_seq(seq, env)
        end
        {:ok, _} ->
          :error
    end
  end

  def eval_expr({:fun, id}, _) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, Env.new()}}
  end

 def eval_match(:ignore, _, env) do {:ok, env} end

 def eval_match({:atom, id}, id, env) do {:ok, env} end

 def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end

  def eval_match({:cons, headPtr, tailPtr}, {headStr, tailStr}, env) do
    case eval_match(headPtr, headStr, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tailPtr, tailStr, env)
    end
  end

  def eval_match(_, _, _) do :fail end

  def eval_scope(ptr, env) do
    Env.remove(extract_vars(ptr), env)
  end

  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end

  def eval_seq([{:match, ptr, exp} | tail], env) do
    case eval_expr(exp, env) do
      :error ->
        :error
      {:ok, str} ->
        env = eval_scope(ptr, env)
        case eval_match(ptr, str, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(tail, env)
        end
    end
  end

  # Extracts all variables from a pattern, returns list
  def extract_vars(ptr) do
    extract_vars(ptr, [])
  end

  def extract_vars({:atom, _}, vars) do vars end

  def extract_vars(:ignore, vars) do vars end

  def extract_vars({:var, var}, vars) do [var | vars] end

  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end

  def eval_cls([], _, _) do :error end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, eval_scope(ptr, env)) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

  def eval_args(args, env) do eval_args(args, env, []) end

  def eval_args([], _, strs) do  {:ok, Enum.reverse(strs)} end

  def eval_args([head | tail], env, strs) do
    case eval_expr(head, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(tail, env, [str | strs])
    end
  end

end
