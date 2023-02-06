defmodule High do

  def test do
    listInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    double_five_animal(listInt, :double)
  end

  def double([]) do [] end
  def double([head | tail]) do [head * 2 | double(tail)] end

  def five([]) do [] end
  def five([head | tail]) do [head + 5 | five(tail)] end

  def animal([]) do [] end
  def animal([head | tail]) do
    if head == :dog do
      [:fido | animal(tail)]
    else
      [head | animal(tail)]
    end
  end

  def double_five_animal([], _) do [] end
  def double_five_animal(list, func) do
    case func do
      :double ->
        double(list)
      :five ->
        five(list)
      :animal ->
        animal(list)
    end
  end
end
