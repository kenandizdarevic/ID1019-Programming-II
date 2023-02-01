defmodule Eager do

  # Create new environment
  def eval(seq) do eval_seq(seq, []) end

  def test do
    seq = [{:match, {:var, :x}, {:atom,:a}},
          {:match, {:var, :y}, {:cons, {:var, :x}, {:atom, :b}}},
          {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
          {:var, :z}]
    eval(seq)
  end

  # ------------ EVALUATION OF EXPRESSION ------------
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
 # ---------------------------------------------------

 # --------------- PATTERN MATCHING ------------------
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
  # Check powerpoint for this rule
  def eval_match({:cons, headPtr, tailPtr}, {headStr, tailStr}, env) do
    case eval_match(headPtr, headStr, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tailPtr, tailStr, env)
    end
  end
  def eval_match(_, _, _) do :fail end

 # ------------------------------------------

 # ----------------- SOCPE -----------------
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
 # -----------------------------------------
  # Extracts all variables from a pattern, returns list
  def extract_vars(ptr) do
    extract_vars(ptr, [])
  end
  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do [var | vars] end
  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end

end
