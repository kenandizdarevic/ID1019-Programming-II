defmodule Hanoi do

  def test do
    hanoi(3, :a, :b, :c)
  end

  def hanoi(0, _, _, _) do [] end

  def hanoi(n, start, mid, finish) do
    hanoi(n-1, start, finish, mid) ++ [{:move, start, finish}] ++ hanoi(n-1, mid, start, finish)
  end
end

# 1. Show that base case works
# 2. Assume that f(n-1) works, includes variety of
# starting and ending positions.
# 3. Show f(n) works with f(n-1)

# ----- STRATEGY -----
# Move the n-1 discs from start to the rod that is not end
# Recursive call on hanoi(n-1, start, notEnd)
# Move last disc from start to end
# Move top n-1 discs from middle to end
# Recursive call with n-1 and mid as starting position

# Total moves are calculated with 2^n - 1
