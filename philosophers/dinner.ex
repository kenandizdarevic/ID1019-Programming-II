defmodule Dinner do
  def start(), do: sapwn(fn -> init() end)

  def init() do
    c1 = Chopstick.start()
    c2 Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()

    ctrl = self()

    Philosopher.start(5, c1, c2, "Arendt", ctrl)
    Philosopher.start(5, c2, c3, "Hypatia", ctrl)
    Philosopher.start(5, c3, c4, "Simone", ctrl)
    Philosopher.start(5, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(5, c5, c1, "Ayn", ctrl)

    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end

  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end
