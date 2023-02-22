defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end

  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn() -> dreaming(hunger, left, right, name, ctrl) end)
  end

  def dreaming(0, _, _, name, ctrl) do
    IO.puts("#{name} is satisfied!")
    send(ctrl, :done)
  end

  def dreaming(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is dreaming!")
    sleep(50)
    IO.puts("#{name} is awake!")
    waiting(hunger, left, right, name, ctrl)
  end

  def eating(hunger, left, right, name, ctrl) do
    sleep(10)
    Chopstick.return(left)
    Chopstick.return(right)
    IO.puts("#{name} has eaten one portion!")
    dreaming(hunger - 1, left, right, name, ctrl)
  end

  # Chopstick.request() will only return :ok
  def waiting(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is waiting for chopsticks!")
    case Chopstick.request(left) do
      :ok ->
        IO.puts("#{name} recieved one chopstick!")
        case Chopstick.request(right) do
          :ok ->
            IO.puts("#{name} is now able to eat!")
            eating(hunger, left, right, name, ctrl)
        end
    end
  end

end
