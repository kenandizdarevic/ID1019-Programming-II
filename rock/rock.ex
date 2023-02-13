defmodule Rock do

  def main do
    # Key-value database with all combinations and points
    points1 = %{{"A", "X"} => 4, {"A", "Y"} => 8, {"A", "Z"} => 3,
                {"B", "X"} => 1, {"B", "Y"} => 5, {"B", "Z"} => 9,
                {"C", "X"} => 7, {"C", "Y"} => 2, {"C", "Z"} => 6}

    points2 = %{{"A", "X"} => 3, {"A", "Y"} => 4, {"A", "Z"} => 8,
                {"B", "X"} => 1, {"B", "Y"} => 5, {"B", "Z"} => 9,
                {"C", "X"} => 2, {"C", "Y"} => 6, {"C", "Z"} => 7}

    IO.puts("Total points task 1: #{calculate(points1)}")
    IO.puts("Total points task 1: #{calculate(points2)}")
  end

  def calculate(points) do
    {:ok, games} = File.read("C:/Users/Kenan/Desktop/Skola/Programmering 2/Programming-2/rock/games.txt")
    matches = String.split(games, "\r\n")
    score = matches
      |> Enum.map(fn match -> String.split(match, " ") end)
      |> Enum.map(fn [opponent, me] -> points[{opponent, me}] end)
      |> Enum.sum
    score
  end
end
