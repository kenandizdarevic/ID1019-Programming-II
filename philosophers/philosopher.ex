defmodule Philosopher do

  # Dreaming and eating time
  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end

  # hunger = number of times philosopher should eat before returning :done
  # right & left = PID of chopstick
  # name = string that is the name of the philosopher
  # ctrl = cotroller process that should be informed when the philosopher is done
  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn() -> dreaming(hunger, left, right, name, ctrl) end)
  end

  def dreaming(hunger, left, right, name, ctrl) do

  end

end
