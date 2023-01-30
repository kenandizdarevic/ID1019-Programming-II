defmodule Evaluate do
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
    | {:add, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}

    # We use Elixirs own Map
    # Create new Map %{}
    # Add keys to map with .put
    # Retrieve keys to map with .get

    def test  do
      bind = [{:a, 1}, {:b, 2}, {:c, 3}]
      env = Map.new(bind)
      expr = {:add, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}}, {:q, 1,2}}

      eval(expr, env)
    end

    def eval({:num, n}, _) do {:num, n} end
    def eval({:var, v}, env) do env.get(v) end
    def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
    def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
    def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
    def eval({:div, e1, e2}, env) do div(eval(e1, env), eval(e2, env)) end

    def add({:num, a}, {:num, b}) do {:num, a + b} end
    def add({:q, n, m}, {:q, x, y}) do {:q, n*y + x*m, m*y} end
    def add({:q, n, m}, {:num, a}) do {:q, a*m + n, m} end
    def add({:num, a}, {:q, n, m}) do {:q, a*m + n, m} end

    def sub({:num, a}, {:num, b}) do {:num, a - b} end
    def sub({:q, n, m}, {:q, x, y}) do {:q, n*y - x*m, m*y} end
    def sub({:q, n, m}, {:num, a}) do {:q, a*m - n, m} end
    def sub({:num, a}, {:q, n, m}) do {:q, a*m - n, m} end

    def mul({:num, a}, {:num, b}) do {:num, a * b} end
    def mul({:q, n, m}, {:q, x, y}) do {:q, n*x, m*y} end
    def mul({:q, n, m}, {:num, a}) do {:q, n*a, m} end
    def mul({:num, a}, {:q, n, m}) do {:q, n*a, m} end

    def div({:num, a}, {:num, b}) do {:num, a / b} end
    def div({:q, n, m}, {:q, x, y}) do {:q, n*y, m*x} end
    def div({:q, n, m}, {:num, a}) do {:q, n, m*a} end
    def div({:num, a}, {:q, n, m}) do {:q, n, m*a} end
end
