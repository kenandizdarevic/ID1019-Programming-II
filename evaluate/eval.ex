defmodule Evaluate do
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

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
      env = %{a: 1, b: 2, c: 3, d: 4}
      expr = {:add, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}}, {:q, 6, 4}}

      eval(expr, env)
    end

    def eval({:num, n}, _) do n end
    def eval({:var, v}, env) do Map.get(env, v) end
    def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
    def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
    def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
    def eval({:div, e1, e2}, env) do divi(eval(e1, env), eval(e2, env)) end
    def eval({:q, e1, e2}, _) do quotient(e1, e2) end

    def add({:q, n, m}, {:q, x, y}) do {:q, n*y + x*m, m*y} end
    def add({:q, n, m}, a) do {:q, a*m + n, m} end
    def add(a, {:q, n, m}) do {:q, a*m + n, m} end
    def add(a, b) do a + b end

    def sub({:q, n, m}, {:q, x, y}) do {:q, n*y - x*m, m*y} end
    def sub({:q, n, m}, a) do {:q, a*m - n, m} end
    def sub(a, {:q, n, m}) do {:q, a*m - n, m} end
    def sub(a, b) do a - b end

    def mul({:q, n, m}, {:q, x, y}) do {:q, n*x, m*y} end
    def mul({:q, n, m}, a) do {:q, n*a, m} end
    def mul(a, {:q, n, m}) do {:q, n*a, m} end
    def mul(a, b) do a * b end

    def divi({:q, n, m}, {:q, x, y}) do {:q, n*y, m*x} end
    def divi({:q, n, m}, a) do {:q, n, m*a} end
    def divi(a, {:q, n, m}) do {:q, n, m*a} end
    def divi(a, b) do a / b end

    def quotient(a, b) do (a / b) / 1.0  end
end
