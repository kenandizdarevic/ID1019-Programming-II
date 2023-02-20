defmodule Monte do
  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r, 2) > :math.pow(x, 2) + :math.pow(y, 2)
  end

  def round(0, _, a) do a end
  def round(k, r, a) do
    case dart(r) do
      true ->
        # hit
        round(k - 1, r, a + 1)
      false ->
        # miss
        round(k - 1, r, a)
    end
  end

  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end

  def rounds(0, _, t, _, a) do 4*a/t end
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi = 4*a/t
    :io.format("pi = ~.10f, error = ~.8f\n", [pi, (pi - :math.pi())])
    rounds(k - 1, j, t, r, a)
  end
end
