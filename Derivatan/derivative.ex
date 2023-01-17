defmodule Derivative do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
    | {:add, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:exp, expr(), literal()}
    | {:ln, expr()}
    | {:div, expr(), expr()}
    | {:sqrt, expr()}
    | {:sin, expr()}

  # ----------- Test cases -----------
  def testMul() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)

    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def testAdd() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def testLn() do
    e = {:ln, {:mul, {:num, 6}, {:var, :x}}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end
  # ----------------------------------

  # Rules for differentiation
  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end

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

  # Exponent rule
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)
    }
  end

  # Rule for ln(x)

  def deriv({:ln, e}, v) do
    {:mul,
      {:div, {:num, 1}, e}, deriv(e, v)
    }
  end

  # Rule for 1/x

  # Rule for sqrt(x)
  # Rule for sin(x)

  # Simplification
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:ln, e}) do
    simplify_ln(simplify(e))
  end
  def simplify(e) do e end

  # Simplification for addition
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0})  do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1+n2}
  end
  def simplify_add(e1, e2)  do {:add, e1, e2} end

  # Simplification for multiplication
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0})  do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1})  do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do
    {:num, n1*n2}
  end
  def simplify_mul(e1, e2)  do {:mul, e1, e2} end

  # Simplification for exponent
  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1})  do e1 end
  def simplify_exp(e1, e2)  do {:exp, e1, e2} end

  # Simplification for ln(x)
  def simplify_ln({:num, 1}) do {:num, 0} end
  def simplify_ln({:num, e}) do {:ln, e} end

  # Simplification for 1/x
  # Simplification for sqrt(x)
  # Simplification for sin(x)

  # Pretty print
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end

  # Pretty print for addition
  def pprint({:add, e1, e2}) do
    "(#{pprint(e1)} + #{pprint(e2)})"
  end

  # Pretty print for multiplication
  def pprint({:mul, e1, e2}) do
    "#{pprint(e1)} * #{pprint(e2)}"
  end

  # Pretty print for exponent
  def pprint({:exp, e1, e2}) do
    "#{pprint(e1)}^(#{pprint(e2)})"
  end

  # Pretty print for ln
  def pprint({:ln, e}) do
    "ln(#{pprint(e)})"
  end

  # Pretty print for division
  def pprint({:div, e1, e2}) do
    "(#{pprint(e1)}/#{pprint(e2)})"
  end

end
