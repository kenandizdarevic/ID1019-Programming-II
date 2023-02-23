defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end

  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn() -> dreaming(hunger, strength, left, right, name, ctrl) end)
  end

  def dreaming(0, strength, _left, _right, name, ctrl) do
    IO.puts("#{name} is satisfied, strength is #{strength}!")
    send(ctrl, :done)
  end

  def dreaming(_hunger, 0, _left, _right, name, ctrl) do
      IO.puts("#{name} has no strength left!")
      send(ctrl, :done)
  end

  def dreaming(hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is dreaming!")
    sleep(500)
    IO.puts("#{name} is awake!")
    waiting(hunger, strength, left, right, name, ctrl)
  end

  def eating(hunger, strength, left, right, name, ctrl, ref) do
    sleep(100)
    Chopstick.return(left, ref)
    Chopstick.return(right, ref)
    IO.puts("#{name} has eaten one portion!")
    dreaming(hunger - 1, strength, left, right, name, ctrl)
  end

  # Chopstick.request() will only return :ok
  def waiting(hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is waiting for chopsticks!")

    ref = make_ref()
    Chopstick.async(left, ref)
    Chopstick.async(right, ref)
    case Chopstick.sync(ref, 1000) do
      :ok ->
        IO.puts("#{name} recieved one chopstick!")
        sleep(3000)
        case Chopstick.sync(ref, 1000) do
          :ok ->
            IO.puts("#{name} is now able to eat!")
            eating(hunger, strength, left, right, name, ctrl, ref)
          :no ->
            IO.puts("#{name} has aborted wait for chopstick, strength is #{strength}!")
            Chopstick.return(left, ref)
            dreaming(hunger, strength - 1, left, right, name, ctrl)
        end
      :no ->
        IO.puts("#{name} has aborted wait for chopstick, strength is #{strength}!")
        dreaming(hunger, strength - 1, left, right, name, ctrl)
    end
  end
end
