defmodule Rock do
  # Key-value database with all combinations and points
  points = %{{"A", "X"} => 4, {"A", "Y"} => 8, {"A", "Z"} => 3,
             {"B", "X"} => 1, {"B", "Y"} => 5, {"B", "Z"} => 9,
             {"C", "X"} => 7, {"C", "Y"} => 2, {"C", "Z"} => 6}

  def calculate(values) do
    games = File.read!("day2\day2.txt")

    score = Enum.reduce(String.split(games, "\n"), 0, fn match, acc ->
      [opponent, me] = String.split(match, " ")
      acc + Map.get(values, {opponent, me}, 0)
    end)
    score
  end
end
