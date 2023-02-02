defmodule Prgm do
  def append() do
    {[:x, :y],
      [{:case, {:var, :x},
        [{:clause, {:atm, []}, [{:var, :y}]},
          {:clause, {:cons, {:var, :hd}, {:var, :tl}},
            [{:cons,
              {:var, :hd},
                {:apply, {:fun, :append}, [{:var, :tl}, {:var, :y}]}}]
        }]
      }]
    }
    end
end
