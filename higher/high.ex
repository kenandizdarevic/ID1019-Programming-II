defmodule High do

  def test do
    listVal = [1, 2, 3, 4, 6, 7, 8]
    listAni = [:cow, :dog, :cat]

    f = fn(x) -> x > 5 end
    filter(listVal, f)
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
  def double_five_animal([head | tail], f) do
    case f do
      :double ->
        [head * 2 | double_five_animal(tail, f)]
      :five ->
        [head + 5 | double_five_animal(tail, f)]
      :animal ->
        case head == :dog do
          true ->
            [:fido | double_five_animal(tail, f)]
          false ->
            [head | double_five_animal(tail, f)]
        end
    end
  end

  def apply_to_all([], _) do [] end
  def apply_to_all([head | tail], f) do
    [f.(head) | apply_to_all(tail, f)]
  end

  def sum([]) do 0 end
  def sum([head | tail]) do head + sum(tail) end

  def prod([]) do 1 end
  def prod([head | tail]) do head * prod(tail) end

  def fold_right([], base, _) do base end
  def fold_right([head | tail], base, f) do
    f.(head, fold_right(tail, base, f))
  end

  def fold_left([], acc, _) do acc end
  def fold_left([head | tail], acc, f) do
    fold_left(tail, f.(head, acc), f)
  end

  def odd([]) do [] end
  def odd([head | tail]) do
    if rem(head, 2) == 1 do
      [head | odd(tail)]
    else
      odd(tail)
    end
  end

  def filter([], _) do [] end
  def filter([head | tail], f) do
    case f.(head) do
      true ->
        [head | filter(tail, f)]
      false ->
         filter(tail, f)
      end
  end

end
