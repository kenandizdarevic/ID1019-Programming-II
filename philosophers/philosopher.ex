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
    case Chopstick.request(left, 1000) do
      :ok ->
        IO.puts("#{name} recieved one chopstick!")
        sleep(1000)
        case Chopstick.request(right, 1000) do
          :ok ->
            IO.puts("#{name} is now able to eat!")
            eating(hunger, left, right, name, ctrl)
          :no ->
            IO.puts("#{name} has aborted wait for chopstick!")
            Chopstick.return(right)
            dreaming(hunger, left, right, name, ctrl)
        end
      :no ->
        IO.puts("#{name} has aborted for chopstick!")
        Chopstick.return(left)
        dreaming(hunger, left, right, name, ctrl)
    end
  end
end
