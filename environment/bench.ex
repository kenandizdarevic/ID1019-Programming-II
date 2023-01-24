defmodule Bench do
  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

    list = Enum.reduce(seq, EnvTree.new(), fn(e, list) ->
      EnvTree.add(list, e, :foo) end)

    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    {add, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.add(list, e, :foo) end) end)

     {lookup, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.lookup(list, e) end) end)

     {remove, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.remove(list, e) end) end)

     {i, add, lookup, remove}
     end
     # Call this to perform the benchmark, n is amount of loops
     def bench(n) do
       ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

       :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
       :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

       Enum.each(ls, fn (i) ->
           {i, tla, tll, tlr} = bench(i, n)
           :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
         end)
  end
end
