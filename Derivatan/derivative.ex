defmodule Derivative do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:sub, expr(), expr()}

  # Test case
  def test() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    deriv(e, :x)
  end

  def deriv({:num, _}, _) do 0 end
  def deriv({:var, v}, v) do 1 end
  def deriv({:var, _}, _) do 0 end

  # Addition rule
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  # Multiplication rule
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}
    }
  end

end
