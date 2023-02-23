defmodule Dinner do
  def start(hunger), do: spawn(fn -> init(hunger) end)

  def init(hunger) do

    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()

    ctrl = self()

    Philosopher.start(hunger, 5, c1, c2, "Arendt", ctrl)
    Philosopher.start(hunger, 5, c2, c3, "Hypatia", ctrl)
    Philosopher.start(hunger, 5, c3, c4, "Simone", ctrl)
    Philosopher.start(hunger, 5, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(hunger, 5, c5, c1, "Ayn", ctrl)

    t0 = :os.system_time(:second)
    wait(5, [c1, c2, c3, c4, c5], t0)
  end

  # Everyone is done, terminate alla chopsticks
  # Philosophers are done, have returned :ok to motherprocess
  def wait(0, chopsticks, t0) do
    Enum.each(chopsticks, fn(c) -> Chopstick.terminate(c) end)
    IO.puts("Dinner completed in #{:os.system_time(:second) - t0}s")
  end

  # Motherprocess can send :abort to kill everything
  def wait(n, chopsticks, t0) do
    receive do
      :done ->
        wait(n - 1, chopsticks, t0)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end
